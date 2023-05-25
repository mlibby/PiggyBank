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

    public Dictionary<string, Price.PriceSourceType> PriceSourceMap = new()
    {
        { "Finance::Quote", Price.PriceSourceType.FinanceQuote },
        { "invalid", Price.PriceSourceType.Invalid },
        { "temporary", Price.PriceSourceType.Temporary },
        { "user:invoice-post", Price.PriceSourceType.Invoice },
        { "user:price", Price.PriceSourceType.UserPrice },
        { "user:price-editor", Price.PriceSourceType.EditDialog },
        { "user:split-import", Price.PriceSourceType.SplitImport },
        { "user:split-register", Price.PriceSourceType.SplitRegister },
        { "user:stock-split", Price.PriceSourceType.StockSplit },
        { "user:stock-transaction", Price.PriceSourceType.StockTransaction },
        { "user:xfer-dialog", Price.PriceSourceType.TransferDialog },
    };

    public Dictionary<string, Price.PriceType> PriceTypeMap = new() {
        {
            { "bid" | "ask" | "last" | "nav" | "transaction" | "unknown" }
    }

    }
}
