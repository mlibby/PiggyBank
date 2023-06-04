namespace PiggyBank.Data.Import.GnuCash.Models;

public partial class GncCommodity
{
    public static readonly Dictionary<string, CommodityType> TypeMap = new()
    {
        {"CURRENCY", CommodityType.Currency },
        {"FUND", CommodityType.Stock },
        {"NYSE", CommodityType.Stock },
    };

    public string Guid { get; set; } = null!;

    public string Namespace { get; set; } = null!;

    public string Mnemonic { get; set; } = null!;

    public string Fullname { get; set; } = null!;

    public string Cusip { get; set; } = null!;

    public long Fraction { get; set; }

    public long QuoteFlag { get; set; }

    public string? QuoteSource { get; set; }

    public string? QuoteTz { get; set; }
}
