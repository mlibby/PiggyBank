namespace PiggyBank.Data.Import.GnuCash.Models;

public partial class GncPrice
{
    public string Guid { get; set; } = null!;

    public string CommodityGuid { get; set; } = null!;

    public string CurrencyGuid { get; set; } = null!;

    public string Date { get; set; } = null!;

    public string? Source { get; set; }

    public string? Type { get; set; }

    public long ValueNumber { get; set; }

    public long ValueDenomination { get; set; }

    public Dictionary<string, PriceSourceType> PriceSourceMap = new()
    {
        { "Finance::Quote", PriceSourceType.FinanceQuote },
        { "invalid", PriceSourceType.Invalid },
        { "temporary", PriceSourceType.Temporary },
        { "user:invoice-post", PriceSourceType.Invoice },
        { "user:price", PriceSourceType.UserPrice },
        { "user:price-editor", PriceSourceType.EditDialog },
        { "user:split-import", PriceSourceType.SplitImport },
        { "user:split-register", PriceSourceType.SplitRegister },
        { "user:stock-split", PriceSourceType.StockSplit },
        { "user:stock-transaction", PriceSourceType.StockTransaction },
        { "user:xfer-dialog", PriceSourceType.TransferDialog },
    };

    //public Dictionary<string, Price.PriceType> PriceTypeMap = new() {
    //    {
    //        { "bid" | "ask" | "last" | "nav" | "transaction" | "unknown" }
    //}

    //}
}
