namespace PiggyBank.Data.Import.GnuCash.Models;

public partial class GncAccount
{
    private static Dictionary<string, Account.AccountType> GnuCashToPiggyBank = new()
    {
        { "ASSET", Account.AccountType.Asset },
        { "BANK", Account.AccountType.Asset },
        { "CASH", Account.AccountType.Asset },
        { "CREDIT", Account.AccountType.Liability },
        { "EQUITY", Account.AccountType.Equity },
        { "EXPENSE", Account.AccountType.Expense },
        { "INCOME", Account.AccountType.Income },
        { "LIABILITY", Account.AccountType.Liability },
        { "MUTUAL", Account.AccountType.Asset },
        { "PAYABLE", Account.AccountType.Liability },
        { "RECEIVABLE", Account.AccountType.Asset },
        { "STOCK", Account.AccountType.Asset },
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

    public Account.AccountType PiggyBankAccountType => GnuCashToPiggyBank[AccountType.ToUpper()];
}