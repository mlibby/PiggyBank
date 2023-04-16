namespace PiggyBank.Import.GnuCash;

public partial class Account
{
    private static Dictionary<string, Models.Account.AccountType> GnuCashToPiggyBank = new Dictionary<string, Models.Account.AccountType>
    {
        { "ASSET", Models.Account.AccountType.Asset },
        { "BANK", Models.Account.AccountType.Asset },
        { "CASH", Models.Account.AccountType.Asset },
        { "CREDIT", Models.Account.AccountType.Liability },
        { "EQUITY", Models.Account.AccountType.Equity },
        { "EXPENSE", Models.Account.AccountType.Expense },
        { "INCOME", Models.Account.AccountType.Income },
        { "LIABILITY", Models.Account.AccountType.Liability },
        { "MUTUAL", Models.Account.AccountType.Asset },
        { "PAYABLE", Models.Account.AccountType.Liability },
        { "RECEIVABLE", Models.Account.AccountType.Asset },
        { "STOCK", Models.Account.AccountType.Asset },
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

    public Models.Account.AccountType PiggyBankAccountType
    {
        get
        {
            return GnuCashToPiggyBank[AccountType.ToUpper()];
        }
    }
}