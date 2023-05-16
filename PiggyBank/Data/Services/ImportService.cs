namespace PiggyBank.Data.Services;

public class ImportService
{
    private GnuCashContext _gnuCashContext;
    private PiggyBankContext _piggyBankContext;

    public ImportService(PiggyBankContext piggyBankContext, GnuCashContext gnuCashContext)
    {
        _gnuCashContext = gnuCashContext;
        _piggyBankContext = piggyBankContext;
    }

    public Task<int> ImportAccounts(IProgress<int> processed, IProgress<int> count, CancellationToken cancellationToken)
    {
        return Task.Run<int>(async () =>
        {
            cancellationToken.ThrowIfCancellationRequested();

            var accounts = new List<GncAccount>();
            var rootAccount = await _gnuCashContext.Accounts
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

                Account? account = await _piggyBankContext.Accounts
                    .SingleOrDefaultAsync(a => a.Id == Guid.Parse(gncAccount.Guid));

                if (account is not object)
                {
                    account = new Account();
                    _piggyBankContext.Accounts.Add(account);
                }

                if (!account.IsLocked)
                {
                    UpdateAccount(gncAccount, account!);
                    await _piggyBankContext.SaveChangesAsync();
                }

                cancellationToken.ThrowIfCancellationRequested();

                processedCount++;
                processed.Report(processedCount);
            }

            return gnuCashAccounts.Count;
        });
    }


    public Task<int> ImportCommodities(IProgress<int> processed, IProgress<int> count, CancellationToken cancellationToken)
    {
        return Task.Run<int>(async () =>
        {
            cancellationToken.ThrowIfCancellationRequested();

            var gncCommodities = await _gnuCashContext.Commodities
                .Where(c => c.Namespace != "template")
                .ToListAsync();
            count.Report(gncCommodities.Count);

            var processedCount = 0;
            foreach (var gncCommodity in gncCommodities)
            {
                var symbol = await _gnuCashContext.Slots
                    .SingleOrDefaultAsync(s => s.ObjGuid == gncCommodity.Guid && s.Name == "user_symbol");

                Guid guid = Guid.Parse(gncCommodity.Guid);
                Commodity? commodity = await _piggyBankContext
                    .Commodities.SingleOrDefaultAsync(c => c.Id == guid);

                if (commodity is not object)
                {
                    commodity = new Commodity();
                    _piggyBankContext.Commodities.Add(commodity);
                }

                if (!commodity.IsLocked)
                {
                    UpdateCommodity(gncCommodity, commodity!, symbol);
                    await _piggyBankContext.SaveChangesAsync();
                }

                cancellationToken.ThrowIfCancellationRequested();

                processedCount++;
                processed.Report(processedCount);
            }

            return gncCommodities.Count;
        });
    }

    public Task<int> ImportTransactions(IProgress<int> processed, IProgress<int> count, CancellationToken cancellationToken)
    {
        return Task.Run<int>(async () =>
        {
            cancellationToken.ThrowIfCancellationRequested();

            var gncTransactions = await _gnuCashContext.Transactions.Include(t => t.Splits).ToListAsync();
            count.Report(gncTransactions.Count);

            var processedCount = 0;
            foreach (var gncTransaction in gncTransactions)
            {
                Transaction? transaction = await _piggyBankContext.Transactions
                    .Include(t => t.Splits)
                    .SingleOrDefaultAsync(t => t.Id == Guid.Parse(gncTransaction.Guid));

                if (transaction is not object)
                {
                    transaction = new Transaction();
                    _piggyBankContext.Transactions.Add(transaction);
                }

                UpdateTransaction(gncTransaction, transaction!);
                await _piggyBankContext.SaveChangesAsync();

                cancellationToken.ThrowIfCancellationRequested();

                processedCount++;
                processed.Report(processedCount);
            }

            return gncTransactions.Count;
        });
    }

    private DateOnly ConvertDate(string? dateString)
    {
        DateTime date = DateTime.Today;
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
    private Task<List<GncAccount>> GetGnuCashAccounts(string parentGuid, List<GncAccount> accounts)
    {
        return Task.Run<List<GncAccount>>(async () =>
        {
            var childAccounts = await _gnuCashContext.Accounts
            .Where(a => a.ParentGuid == parentGuid)
            .ToListAsync();

            accounts.AddRange(childAccounts);
            foreach (var childAccount in childAccounts)
            {
                await GetGnuCashAccounts(childAccount.Guid, accounts);
            }

            return accounts;
        });
    }

    private void UpdateAccount(GncAccount gncAccount, Account account)
    {
        account.Id = Guid.Parse(gncAccount.Guid);
        account.Name = gncAccount.Name;
        account.ParentId = gncAccount.ParentGuid is object ? Guid.Parse(gncAccount.ParentGuid!) : null;
        account.Description = gncAccount.Description!;
        account.CommodityId = Guid.Parse(gncAccount.CommodityGuid!);
        account.Type = gncAccount.PiggyBankAccountType;
        account.IsPlaceholder = gncAccount.Placeholder > 0;
        account.IsHidden = gncAccount.Hidden > 0;
    }

    private void UpdateCommodity(GncCommodity gncCommodity, Commodity commodity, GncSlot? symbol)
    {
        commodity.Id = Guid.Parse(gncCommodity.Guid);
        commodity.Cusip = gncCommodity.Cusip;
        commodity.Mnemonic = gncCommodity.Mnemonic;
        commodity.Name = gncCommodity.Fullname;
        commodity.Precision = gncCommodity.Fraction.ToString().Length - 1;
        commodity.Symbol = symbol?.StringVal;
        commodity.Type = GncCommodity.TypeMap[gncCommodity.Namespace];
    }

    private void UpdateSplit(GncSplit gncSplit, Split split)
    {
        split.Id = Guid.Parse(gncSplit.Guid);
        split.AccountId = Guid.Parse(gncSplit.AccountGuid);
        split.Memo = gncSplit.Memo;
        split.Action = gncSplit.Action;
        split.Value = new Decimal(gncSplit.ValueNumber) / new Decimal(gncSplit.ValueDenomination);
        split.Quantity = new Decimal(gncSplit.QuantityNumber) / new Decimal(gncSplit.QuantityDenomination);
    }

    private void UpdateTransaction(GncTransaction gncTransaction, Transaction transaction)
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
            Split? split = transaction.Splits
                .SingleOrDefault(s => s.Id == Guid.Parse(gncSplit.Guid));

            if (split is object)
            {
                originalSplitGuids.Remove(split.Id);
                UpdateSplit(gncSplit, split);
                continue;
            }

            split = new Split();
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