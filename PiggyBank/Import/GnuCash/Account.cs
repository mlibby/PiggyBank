namespace PiggyBank.Import.GnuCash;

public partial class Account
{
    private static Dictionary<string, Models.Account.Type> GnuCashToPiggyBank = new Dictionary<string, Models.Account.Type>
    {
        { "ASSET", Models.Account.Type.Asset },
        { "BANK", Models.Account.Type.Asset },
        { "CASH", Models.Account.Type.Asset },
        { "CREDIT", Models.Account.Type.Liability },
        { "EQUITY", Models.Account.Type.Equity },
        { "EXPENSE", Models.Account.Type.Expense },
        { "INCOME", Models.Account.Type.Income },
        { "LIABILITY", Models.Account.Type.Liability },
        { "MUTUAL", Models.Account.Type.Asset },
        { "PAYABLE", Models.Account.Type.Liability },
        { "RECEIVABLE", Models.Account.Type.Asset },
        { "STOCK", Models.Account.Type.Asset },
    };

    public string Guid { get; set; } = null!;

    public string Name { get; set; } = null!;

    public string AccountType { get; set; } = null!;

    public string? CommodityGuid { get; set; }

    public long CommodityScu { get; set; }

    public long NonStdScu { get; set; }

    public string? ParentGuid { get; set; }

    public string? Code { get; set; }

    public string? Description { get; set; }

    public long? Hidden { get; set; }

    public long? Placeholder { get; set; }

    public Models.Account.Type PiggyBankAccountType
    {
        get
        {
            return GnuCashToPiggyBank[AccountType.ToUpper()];
        }
    }
}