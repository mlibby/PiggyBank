namespace PiggyBank.Data.Import.GnuCash;

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
}
