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
        var accounts = new List<Import.GnuCash.Account>();
        var rootAccount = GnuCashContext.Accounts.Single(a => a.AccountType == "ROOT" && a.Name == "Root Account");
        var gnuCashAccounts = GetGnuCashAccounts(rootAccount.Guid, accounts);
        foreach (var gcAccount in gnuCashAccounts)
        {
            if (gcAccount.ParentGuid == rootAccount.Guid)
            {
                gcAccount.ParentGuid = null;
            }

            Models.Account? account = PiggyBankContext.Accounts.SingleOrDefault(a => a.Id == Guid.Parse(gcAccount.Guid));
            if (account is object && !account.IsLocked)
            {
                UpdateAccount(gcAccount, account!);
                PiggyBankContext.SaveChanges();
                continue;
            }

            account = new Models.Account();
            PiggyBankContext.Accounts.Add(account);
            UpdateAccount(gcAccount, account!);
            PiggyBankContext.SaveChanges();
        }
    }

    public void ImportCommodities()
    {
        foreach (var gcCommodity in GnuCashContext.Commodities)
        {
            if (gcCommodity.Namespace == "template") continue;

            var symbol = GnuCashContext.Slots.SingleOrDefault(s => s.ObjGuid == gcCommodity.Guid && s.Name == "user_symbol");

            Guid guid = Guid.Parse(gcCommodity.Guid);
            Models.Commodity? commodity = PiggyBankContext.Commodities.SingleOrDefault(c => c.Id == guid);
            if (commodity is object)
            {
                UpdateCommodity(gcCommodity, commodity!, symbol);
                PiggyBankContext.SaveChanges();
                continue;
            }

            commodity = new Models.Commodity();
            PiggyBankContext.Commodities.Add(commodity);
            UpdateCommodity(gcCommodity, commodity!, symbol);
            PiggyBankContext.SaveChanges();
        }
    }

    public void ImportTransactions()
    {
        foreach (var gcTransaction in GnuCashContext.Transactions.Include(t => t.Splits))
        {
            Models.Transaction? transaction = PiggyBankContext.Transactions.Include(t => t.Splits).SingleOrDefault(t => t.Id == Guid.Parse(gcTransaction.Guid));
            if (transaction is object)
            {
                UpdateTransaction(gcTransaction, transaction!);
                PiggyBankContext.SaveChanges();
                continue;
            }

            transaction = new Models.Transaction();
            PiggyBankContext.Transactions.Add(transaction);
            UpdateTransaction(gcTransaction, transaction);
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
    private List<Import.GnuCash.Account> GetGnuCashAccounts(string parentGuid, List<Import.GnuCash.Account> accounts)
    {
        var childAccounts = GnuCashContext.Accounts.Where(a => a.ParentGuid == parentGuid).ToList();
        accounts.AddRange(childAccounts);
        foreach (var childAccount in childAccounts)
        {
            GetGnuCashAccounts(childAccount.Guid, accounts);
        }

        return accounts;
    }

    private void UpdateCommodity(Import.GnuCash.Commodity gcCommodity, Models.Commodity commodity, Import.GnuCash.Slot? symbol)
    {
        commodity.Id = Guid.Parse(gcCommodity.Guid);
        commodity.Cusip = gcCommodity.Cusip;
        commodity.Mnemonic = gcCommodity.Mnemonic;
        commodity.Name = gcCommodity.Fullname;
        commodity.Precision = gcCommodity.Fraction.ToString().Length - 1;
        commodity.Symbol = symbol?.StringVal;
        commodity.Type = Import.GnuCash.Commodity.TypeMap[gcCommodity.Namespace];
    }

    private void UpdateAccount(Import.GnuCash.Account gcAccount, Models.Account account)
    {
        account.Id = Guid.Parse(gcAccount.Guid);
        account.Name = gcAccount.Name;
        account.ParentId = gcAccount.ParentGuid is object ? Guid.Parse(gcAccount.ParentGuid!) : null;
        account.Description = gcAccount.Description!;
        account.CommodityId = Guid.Parse(gcAccount.CommodityGuid!);
        account.IsPlaceholder = gcAccount.Placeholder > 0;
        account.IsHidden = gcAccount.Hidden > 0;
    }

    private void UpdateTransaction(Import.GnuCash.Transaction gcTransaction, Models.Transaction transaction)
    {
        transaction.Id = Guid.Parse(gcTransaction.Guid);
        transaction.Description = gcTransaction.Description ?? "";
        transaction.EnterDate = ConvertDate(gcTransaction.EnterDate);
        transaction.PostDate = ConvertDate(gcTransaction.PostDate);
        transaction.CommodityId = Guid.Parse(gcTransaction.CurrencyGuid);

        var originalSplitGuids = transaction.Splits.Select(s => s.Id).ToList();
        foreach (var gcSplit in gcTransaction.Splits)
        {
            Models.Split? split = transaction.Splits.SingleOrDefault(s => s.Id == Guid.Parse(gcSplit.Guid));
            if (split is object)
            {
                originalSplitGuids.Remove(split.Id);
                UpdateSplit(gcSplit, split);
                continue;
            }

            split = new Models.Split();
            transaction.Splits.Add(split);
            UpdateSplit(gcSplit, split);
        }

        foreach (var guid in originalSplitGuids)
        {
            var split = transaction.Splits.Single(s => s.Id == guid);
            transaction.Splits.Remove(split);
        }
    }

    private void UpdateSplit(Import.GnuCash.Split gcSplit, Models.Split split)
    {
        split.Id = Guid.Parse(gcSplit.Guid);
        split.AccountId = Guid.Parse(gcSplit.AccountGuid);
        split.Memo = gcSplit.Memo;
        split.Action = gcSplit.Action;
        split.Value = new Decimal(gcSplit.ValueNumber) / new Decimal(gcSplit.ValueDenomination);
        split.Quantity = new Decimal(gcSplit.QuantityNumber) / new Decimal(gcSplit.QuantityDenomination);
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
