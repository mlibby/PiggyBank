namespace PiggyBank.Data.Models;

public partial class Price
{
    public enum PriceSourceType
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
}
