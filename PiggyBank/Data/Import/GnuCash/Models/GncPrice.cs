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

    public Dictionary<string, PriceSource> PriceSourceMap = new()
    {
        { "Finance::Quote", PriceSource.FinanceQuote },
        { "invalid", PriceSource.Invalid },
        { "temporary", PriceSource.Temporary },
        { "user:invoice-post", PriceSource.Invoice },
        { "user:price", PriceSource.UserPrice },
        { "user:price-editor", PriceSource.EditDialog },
        { "user:split-import", PriceSource.SplitImport },
        { "user:split-register", PriceSource.SplitRegister },
        { "user:stock-split", PriceSource.StockSplit },
        { "user:stock-transaction", PriceSource.StockTransaction },
        { "user:xfer-dialog", PriceSource.TransferDialog },
    };

    //public Dictionary<string, Price.PriceType> PriceTypeMap = new() {
    //    {
    //        { "bid" | "ask" | "last" | "nav" | "transaction" | "unknown" }
    //}

    //}
}
