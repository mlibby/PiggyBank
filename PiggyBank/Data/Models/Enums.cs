namespace PiggyBank.Enums;

public enum AccountType
{
    Asset = 1,
    Equity = 2,
    Expense = 3,
    Income = 4,
    Liability = 5,
    Invalid = 6
}

public enum AmountType
{
    Monthly = 1,
    Annual = 12,
}

public enum CommodityType
{
    Asset = 1,
    Currency = 2,
    Stock = 3,
}

public enum DataSource
{
    User = 1,
    GnuCash = 2,
    Ofx = 3,
}

public enum PriceSource
{
    EditDialog = 1,
    FinanceQuote = 2,
    Invalid = 3,
    Invoice = 4,
    SplitImport = 5,
    SplitRegister = 6,
    StockSplit = 7,
    StockTransaction = 8,
    Temporary = 9,
    TransferDialog = 10,
    UserPrice = 11,
}

public enum PriceType
{
    Ask = 1,
    Bid = 2,
    Last = 3,
    NetAssetValue = 4,
    Transaction = 5,
    Unknown = 6,
}

public enum SettingType
{
    DefaultBudgetId = 1
}
