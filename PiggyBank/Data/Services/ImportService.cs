using PiggyBank.Data.Import.GnuCash.Models;

namespace PiggyBank.Data.Services;

public record ImportService(GnuCashContext GnuCashContext, PiggyBankContext PiggyBankContext)
{
    public Task<int> ImportAccounts(IProgress<int> processed, IProgress<int> count, CancellationToken cancellationToken) =>
        Task.Run(async () =>
        {
            cancellationToken.ThrowIfCancellationRequested();

            var accounts = new List<GncAccount>();
            var rootAccount = await GnuCashContext.Accounts
                .SingleAsync(a => a.AccountType == "ROOT" && a.Name == "Root Account");

            var gnuCashAccounts = await GetGnuCashAccounts(rootAccount.Guid, accounts);
            count.Report(gnuCashAccounts.Count);

            var processedCount = 0;
            foreach (var gncAccount in gnuCashAccounts)
            {
                if (gncAccount.ParentGuid == rootAccount.Guid)
                {
                    gncAccount.ParentGuid = null;
                }

                var account = await PiggyBankContext.Accounts
                    .SingleOrDefaultAsync(a => a.Id == Guid.Parse(gncAccount.Guid));

                if (account is null)
                {
                    account = new Account()
                    {
                        Source = Source.SourceType.GnuCash
                    };
                    PiggyBankContext.Accounts.Add(account);
                }

                if (!account.IsLocked)
                {
                    UpdateAccount(gncAccount, account!);
                    await PiggyBankContext.SaveChangesAsync();
                }

                cancellationToken.ThrowIfCancellationRequested();

                processedCount++;
                processed.Report(processedCount);
            }

            return gnuCashAccounts.Count;
        });

    public Task<int> ImportCommodities(IProgress<int> processed, IProgress<int> count, CancellationToken cancellationToken) =>
        Task.Run(async () =>
        {
            cancellationToken.ThrowIfCancellationRequested();

            var gncCommodities = await GnuCashContext.Commodities
                .Where(c => c.Namespace != "template")
                .ToListAsync();
            count.Report(gncCommodities.Count);

            var processedCount = 0;
            foreach (var gncCommodity in gncCommodities)
            {
                var symbol = await GnuCashContext.Slots
                    .SingleOrDefaultAsync(s => s.ObjGuid == gncCommodity.Guid && s.Name == "user_symbol");

                var guid = Guid.Parse(gncCommodity.Guid);
                var commodity = await PiggyBankContext
                    .Commodities.SingleOrDefaultAsync(c => c.Id == guid);

                if (commodity is null)
                {
                    commodity = new Commodity()
                    {
                        Source = Source.SourceType.GnuCash
                    };
                    PiggyBankContext.Commodities.Add(commodity);
                }

                if (!commodity.IsLocked)
                {
                    UpdateCommodity(gncCommodity, commodity!, symbol);
                    await PiggyBankContext.SaveChangesAsync();
                }

                cancellationToken.ThrowIfCancellationRequested();

                processedCount++;
                processed.Report(processedCount);
            }

            return gncCommodities.Count;
        });

    public Task<int> ImportTransactions(IProgress<int> processed, IProgress<int> count, CancellationToken cancellationToken) =>
        Task.Run(async () =>
        {
            cancellationToken.ThrowIfCancellationRequested();

            var gncTransactions = await GnuCashContext.Transactions.Include(t => t.Splits).ToListAsync();
            count.Report(gncTransactions.Count);

            var existingTransactionIds = await PiggyBankContext.Transactions
                .Where(t => t.Source == Source.SourceType.GnuCash)
                .Select(t => t.Id)
                .ToListAsync();

            var processedCount = 0;
            foreach (var gncTransaction in gncTransactions)
            {
                var transaction = await PiggyBankContext.Transactions
                    .Include(t => t.Splits)
                    .SingleOrDefaultAsync(t => t.Id == Guid.Parse(gncTransaction.Guid));

                if (transaction is null)
                {
                    transaction = new Transaction()
                    {
                        Source = Source.SourceType.GnuCash
                    };
                    PiggyBankContext.Transactions.Add(transaction);
                }

                UpdateTransaction(gncTransaction, transaction!);
                await PiggyBankContext.SaveChangesAsync();

                existingTransactionIds.Remove(transaction.Id);

                cancellationToken.ThrowIfCancellationRequested();

                processedCount++;
                processed.Report(processedCount);
            }

            // TODO: delete transactions that were not found again -- need flag

            return gncTransactions.Count;
        });

    private static DateOnly ConvertDate(string? dateString)
    {
        var date = DateTime.Today;
        if (!string.IsNullOrWhiteSpace(dateString))
        {
            date = DateTime.Parse(dateString);
        }

        return DateOnly.FromDateTime(date);
    }

    /// <summary>
    /// Returns a list of GnuCash accounts in order from parent to child.
    /// Useful for imports so that relationship to parent will be valid on insert.
    /// </summary>
    /// <param name="gnuCashContext"></param>
    /// <param name="parentGuid"></param>
    /// <param name="accounts"></param>
    /// <returns></returns>
    private Task<List<GncAccount>> GetGnuCashAccounts(string parentGuid, List<GncAccount> accounts) =>
        Task.Run(async () =>
        {
            var childAccounts = await GnuCashContext.Accounts
            .Where(a => a.ParentGuid == parentGuid)
            .ToListAsync();

            accounts.AddRange(childAccounts);
            foreach (var childAccount in childAccounts)
            {
                await GetGnuCashAccounts(childAccount.Guid, accounts);
            }

            return accounts;
        });

    private static void UpdateAccount(GncAccount gncAccount, Account account)
    {
        account.Id = Guid.Parse(gncAccount.Guid);
        account.Name = gncAccount.Name;
        account.ParentId = gncAccount.ParentGuid is not null ? Guid.Parse(gncAccount.ParentGuid!) : null;
        account.Description = gncAccount.Description!;
        account.CommodityId = Guid.Parse(gncAccount.CommodityGuid!);
        account.Type = gncAccount.PiggyBankAccountType;
        account.IsPlaceholder = gncAccount.Placeholder > 0;
        account.IsHidden = gncAccount.Hidden > 0;
    }

    private static void UpdateCommodity(GncCommodity gncCommodity, Commodity commodity, GncSlot? symbol)
    {
        commodity.Id = Guid.Parse(gncCommodity.Guid);
        commodity.Cusip = gncCommodity.Cusip;
        commodity.Mnemonic = gncCommodity.Mnemonic;
        commodity.Name = gncCommodity.Fullname;
        commodity.Precision = gncCommodity.Fraction.ToString().Length - 1;
        commodity.Symbol = symbol?.StringVal;
        commodity.Type = GncCommodity.TypeMap[gncCommodity.Namespace];
    }

    private static void UpdateSplit(GncSplit gncSplit, Split split)
    {
        split.Id = Guid.Parse(gncSplit.Guid);
        split.AccountId = Guid.Parse(gncSplit.AccountGuid);
        split.Memo = gncSplit.Memo;
        split.Action = gncSplit.Action;
        split.Value = new decimal(gncSplit.ValueNumber) / new decimal(gncSplit.ValueDenomination);
        split.Quantity = new decimal(gncSplit.QuantityNumber) / new decimal(gncSplit.QuantityDenomination);
    }

    private static void UpdateTransaction(GncTransaction gncTransaction, Transaction transaction)
    {
        transaction.Id = Guid.Parse(gncTransaction.Guid);
        transaction.Description = gncTransaction.Description ?? "";
        transaction.PostDate = ConvertDate(gncTransaction.PostDate);
        transaction.CommodityId = Guid.Parse(gncTransaction.CurrencyGuid);

        var originalSplitGuids = transaction.Splits
            .Select(s => s.Id)
            .ToList();

        foreach (var gncSplit in gncTransaction.Splits)
        {
            var split = transaction.Splits
                .SingleOrDefault(s => s.Id == Guid.Parse(gncSplit.Guid));

            if (split is not null)
            {
                originalSplitGuids.Remove(split.Id);
                UpdateSplit(gncSplit, split);
                continue;
            }

            split = new Split()
            {
                Source = Source.SourceType.GnuCash
            };

            transaction.Splits.Add(split);
            UpdateSplit(gncSplit, split);
        }

        foreach (var guid in originalSplitGuids)
        {
            var split = transaction.Splits.Single(s => s.Id == guid);
            transaction.Splits.Remove(split);
        }
    }
}
