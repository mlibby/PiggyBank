namespace PiggyBank.Import.GnuCash;

public partial class Commodity
{
    public static readonly Dictionary<string, Models.Commodity.CommodityType> TypeMap = new Dictionary<string, Models.Commodity.CommodityType>()
    {
        {"CURRENCY", Models.Commodity.CommodityType.Currency },
        {"FUND", Models.Commodity.CommodityType.Stock },
        {"NYSE", Models.Commodity.CommodityType.Stock },
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
