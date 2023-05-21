namespace PiggyBank.Data.Models;

public partial class Commodity : SourceModelBase
{
    public string Name { get; set; } = null!;

    public string? Symbol { get; set; }

    public CommodityType Type { get; set; }

    public string Cusip { get; set; } = null!;

    public int Precision { get; set; }

    public string Mnemonic { get; set; } = null!;

    public bool IsLocked { get; set; }
}
