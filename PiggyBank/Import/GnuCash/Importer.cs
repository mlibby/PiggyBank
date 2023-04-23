namespace PiggyBank.Import.GnuCash;

public class Importer
{
    private IGnuCashContext GnuCashContext { get; }
    private IPiggyBankContext PiggyBankContext { get; }

    public Importer(IGnuCashContext context, IPiggyBankContext piggyBankContext)
    {
        GnuCashContext = context;
        PiggyBankContext = piggyBankContext;
    }

    public void ImportAccounts()
    {
        var accounts = new List<GncAccount>();
        var rootAccount = GnuCashContext.Accounts.Single(a => a.AccountType == "ROOT" && a.Name == "Root Account");
        var gnuCashAccounts = GetGnuCashAccounts(rootAccount.Guid, accounts);
        foreach (var gncAccount in gnuCashAccounts)
        {
            if (gncAccount.ParentGuid == rootAccount.Guid)
            {
                gncAccount.ParentGuid = null;
            }

            Account? account = PiggyBankContext.Accounts.SingleOrDefault(a => a.Id == Guid.Parse(gncAccount.Guid));
            if (account is object && !account.IsLocked)
            {
                UpdateAccount(gncAccount, account!);
                PiggyBankContext.SaveChanges();
                continue;
            }

            account = new Account();
            PiggyBankContext.Accounts.Add(account);
            UpdateAccount(gncAccount, account!);
            PiggyBankContext.SaveChanges();
        }
    }

    public void ImportCommodities()
    {
        foreach (var gncCommodity in GnuCashContext.Commodities)
        {
            if (gncCommodity.Namespace == "template") continue;

            var symbol = GnuCashContext.Slots.SingleOrDefault(s => s.ObjGuid == gncCommodity.Guid && s.Name == "user_symbol");

            Guid guid = Guid.Parse(gncCommodity.Guid);
            Commodity? commodity = PiggyBankContext.Commodities.SingleOrDefault(c => c.Id == guid);
            if (commodity is object)
            {
                UpdateCommodity(gncCommodity, commodity!, symbol);
                PiggyBankContext.SaveChanges();
                continue;
            }

            commodity = new Commodity();
            PiggyBankContext.Commodities.Add(commodity);
            UpdateCommodity(gncCommodity, commodity!, symbol);
            PiggyBankContext.SaveChanges();
        }
    }

    public void ImportTransactions()
    {
        foreach (var gncTransaction in GnuCashContext.Transactions.Include(t => t.Splits))
        {
            Transaction? transaction = PiggyBankContext.Transactions
                .Include(t => t.Splits)
                .SingleOrDefault(t => t.Id == Guid.Parse(gncTransaction.Guid));

            if (transaction is object)
            {
                UpdateTransaction(gncTransaction, transaction!);
                PiggyBankContext.SaveChanges();
                continue;
            }

            transaction = new Transaction();
            PiggyBankContext.Transactions.Add(transaction);
            UpdateTransaction(gncTransaction, transaction);
            PiggyBankContext.SaveChanges();
        }
    }

    /// <summary>
    /// Returns a list of GnuCash accounts in order from parent to child.
    /// Useful for imports so that relationship to parent will be valid on insert.
    /// </summary>
    /// <param name="gnuCashContext"></param>
    /// <param name="parentGuid"></param>
    /// <param name="accounts"></param>
    /// <returns></returns>
    private List<GncAccount> GetGnuCashAccounts(string parentGuid, List<GncAccount> accounts)
    {
        var childAccounts = GnuCashContext.Accounts.Where(a => a.ParentGuid == parentGuid).ToList();
        accounts.AddRange(childAccounts);
        foreach (var childAccount in childAccounts)
        {
            GetGnuCashAccounts(childAccount.Guid, accounts);
        }

        return accounts;
    }

    private void UpdateCommodity(GncCommodity gncCommodity, Commodity commodity, GncSlot? symbol)
    {
        commodity.Id = Guid.Parse(gncCommodity.Guid);
        commodity.Cusip = gncCommodity.Cusip;
        commodity.Mnemonic = gncCommodity.Mnemonic;
        commodity.Name = gncCommodity.Fullname;
        commodity.Precision = gncCommodity.Fraction.ToString().Length - 1;
        commodity.Symbol = symbol?.StringVal;
        commodity.Type = Import.GnuCash.GncCommodity.TypeMap[gncCommodity.Namespace];
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

    private void UpdateTransaction(GncTransaction gncTransaction, Transaction transaction)
    {
        transaction.Id = Guid.Parse(gncTransaction.Guid);
        transaction.Description = gncTransaction.Description ?? "";
        transaction.EnterDate = ConvertDate(gncTransaction.EnterDate);
        transaction.PostDate = ConvertDate(gncTransaction.PostDate);
        transaction.CommodityId = Guid.Parse(gncTransaction.CurrencyGuid);

        var originalSplitGuids = transaction.Splits.Select(s => s.Id).ToList();
        foreach (var gncSplit in gncTransaction.Splits)
        {
            Split? split = transaction.Splits.SingleOrDefault(s => s.Id == Guid.Parse(gncSplit.Guid));
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

    private void UpdateSplit(GncSplit gncSplit, Split split)
    {
        split.Id = Guid.Parse(gncSplit.Guid);
        split.AccountId = Guid.Parse(gncSplit.AccountGuid);
        split.Memo = gncSplit.Memo;
        split.Action = gncSplit.Action;
        split.Value = new Decimal(gncSplit.ValueNumber) / new Decimal(gncSplit.ValueDenomination);
        split.Quantity = new Decimal(gncSplit.QuantityNumber) / new Decimal(gncSplit.QuantityDenomination);
    }

    private DateTime ConvertDate(string? dateString)
    {
        if (string.IsNullOrWhiteSpace(dateString))
        {
            return DateTime.UtcNow;
        }

        return DateTime.Parse(dateString);
    }
}
