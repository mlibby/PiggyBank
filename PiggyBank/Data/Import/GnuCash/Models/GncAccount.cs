namespace PiggyBank.Data.Import.GnuCash.Models;

public partial class GncAccount
{
    private static Dictionary<string, AccountType> s_gnuCashToPiggyBank = new()
    {
        { "ASSET", AccountType.Asset },
        { "BANK", AccountType.Asset },
        { "CASH", AccountType.Asset },
        { "CREDIT", AccountType.Liability },
        { "EQUITY", AccountType.Equity },
        { "EXPENSE", AccountType.Expense },
        { "INCOME", AccountType.Income },
        { "LIABILITY", AccountType.Liability },
        { "MUTUAL", AccountType.Asset },
        { "PAYABLE", AccountType.Liability },
        { "RECEIVABLE", AccountType.Asset },
        { "STOCK", AccountType.Asset },
    };

    public string Guid { get; set; } = null!;

    public string Name { get; set; } = null!;

    public string GncAccountType { get; set; } = null!;

    public string? CommodityGuid { get; set; }

    public long CommodityScu { get; set; }

    public long NonStdScu { get; set; }

    public string? ParentGuid { get; set; }

    public string? Code { get; set; }

    public string? Description { get; set; }

    public long? Hidden { get; set; }

    public long? Placeholder { get; set; }

    public AccountType PiggyBankAccountType => s_gnuCashToPiggyBank[GncAccountType.ToUpper()];
}
