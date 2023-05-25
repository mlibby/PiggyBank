namespace PiggyBank.Data.Models;

public partial class Price
{
    public enum PriceSourceType
    {
        EditDialog,
        FinanceQuote,
        Invalid,
        Invoice,
        SplitImport,
        SplitRegister,
        StockSplit,
        StockTransaction,
        Temporary,
        TransferDialog,
        UserPrice,
    }
}
