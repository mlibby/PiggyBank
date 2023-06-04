namespace PiggyBank.Data.Models;

public partial class Commodity : SourceModelBase
{
    [Required]
    [StringLength(255)]
    public string Name { get; set; } = null!;

    [StringLength(1)]
    public string? Symbol { get; set; }

    public CommodityType CommodityType { get; set; }

    [StringLength(255)]
    public string Cusip { get; set; } = null!;

    public int Precision { get; set; }

    [StringLength(255)]
    public string Mnemonic { get; set; } = null!;

    public bool IsLocked { get; set; }
}
