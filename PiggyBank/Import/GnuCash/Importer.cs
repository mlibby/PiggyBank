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
            if (string.IsNullOrEmpty(gcAccount.CommodityGuid)) throw new Exception($"Account {gcAccount.Guid} has no commodity");

            var commodityId = Models.ExternalId.GetCommodityId(PiggyBankContext, gcAccount.CommodityGuid, ExternalId.SourceType.GnuCash);
            if (commodityId is not object) throw new Exception($"Account {gcAccount.Guid} refers to missing commodity {gcAccount.CommodityGuid}");

            var accountId = Models.ExternalId.GetAccountId(PiggyBankContext, gcAccount.Guid, ExternalId.SourceType.GnuCash);

            ExternalId? parentId = null;
            if (gcAccount.ParentGuid != rootAccount.Guid)
            {
                parentId = Models.ExternalId.GetAccountId(PiggyBankContext, gcAccount.ParentGuid!, ExternalId.SourceType.GnuCash);
                if (parentId is not object) throw new Exception($"Account {gcAccount.Guid} refers to missing parent account {gcAccount.ParentGuid}");
            }

            Models.Account? account = null;
            if (accountId is object)
            {
                account = PiggyBankContext.Accounts.SingleOrDefault(a => a.Id == accountId.LocalId);
                if (account is object)
                {
                    UpdateAccount(gcAccount, account!, commodityId.LocalId, parentId?.LocalId);
                    continue;
                }
            }

            account = new Models.Account();
            PiggyBankContext.Accounts.Add(account);
            UpdateAccount(gcAccount, account!, commodityId.LocalId, parentId?.LocalId);
            Models.ExternalId.UpdateExternalId(PiggyBankContext, gcAccount.Guid, account.Id, ExternalId.IdType.Account, ExternalId.SourceType.GnuCash);
        }
    }

    public void ImportCommodities()
    {
        foreach (var gcCommodity in GnuCashContext.Commodities)
        {
            if (gcCommodity.Namespace == "template") continue;

            var commodityId = Models.ExternalId.GetCommodityId(PiggyBankContext, gcCommodity.Guid, ExternalId.SourceType.GnuCash);
            var symbol = GnuCashContext.Slots.SingleOrDefault(s => s.ObjGuid == gcCommodity.Guid && s.Name == "user_symbol");

            Models.Commodity? commodity = null;
            if (commodityId is object)
            {
                commodity = PiggyBankContext.Commodities.SingleOrDefault(c => c.Id == commodityId.LocalId);
                if (commodity is object)
                {
                    UpdateCommodity(gcCommodity, commodity!, symbol);
                    continue;
                }
            }

            commodity = new Models.Commodity();
            PiggyBankContext.Commodities.Add(commodity);
            UpdateCommodity(gcCommodity, commodity!, symbol);
            Models.ExternalId.UpdateExternalId(PiggyBankContext, gcCommodity.Guid, commodity.Id, ExternalId.IdType.Commodity, ExternalId.SourceType.GnuCash);
        }
    }

    public void ImportTransactions()
    {
        foreach (var gcTransaction in GnuCashContext.Transactions.Include(t => t.Splits))
        {
            var transactionId = Models.ExternalId.GetTransactionId(PiggyBankContext, gcTransaction.Guid, ExternalId.SourceType.GnuCash);

            Models.Transaction? transaction = null;
            if (transactionId is object)
            {
                transaction = PiggyBankContext.Transactions.SingleOrDefault(t => t.Id == transactionId.LocalId);
                if (transaction is object)
                {
                    UpdateTransaction(gcTransaction, transaction!, 0);
                    continue;
                }
            }

            transaction = new Models.Transaction();
            PiggyBankContext.Transactions.Add(transaction);
            UpdateTransaction(gcTransaction, transaction, 0);
            Models.ExternalId.UpdateExternalId(PiggyBankContext, gcTransaction.Guid, transaction.Id, ExternalId.IdType.Transaction, ExternalId.SourceType.GnuCash);
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
        commodity.Cusip = gcCommodity.Cusip;
        commodity.Mnemonic = gcCommodity.Mnemonic;
        commodity.Name = gcCommodity.Fullname;
        commodity.Precision = gcCommodity.Fraction.ToString().Length - 1;
        commodity.Symbol = symbol?.StringVal;
        commodity.Type = Import.GnuCash.Commodity.TypeMap[gcCommodity.Namespace];
        PiggyBankContext.SaveChanges();
    }

    private void UpdateAccount(Import.GnuCash.Account gcAccount, Models.Account account, int commodityId, int? parentId)
    {
        account.Name = gcAccount.Name;
        account.ParentId = parentId;
        account.Description = gcAccount.Description!;
        account.CommodityId = commodityId;
        account.IsPlaceholder = gcAccount.Placeholder > 0;
        PiggyBankContext.SaveChanges();
    }

    private void UpdateTransaction(Import.GnuCash.Transaction gcTransaction, Models.Transaction transaction, int commodityId)
    {
        transaction.Description = gcTransaction.Description ?? "";
        transaction.EnterDate = ConvertDate(gcTransaction.EnterDate);
        transaction.PostDate = ConvertDate(gcTransaction.PostDate);
        transaction.CommodityId = commodityId;
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
