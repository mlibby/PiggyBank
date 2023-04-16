namespace PiggyBank.Models;

public partial class Commodity
{
    public int Id { get; set; }

    public string Name { get; set; } = null!;

    public string Symbol { get; set; } = null!;

    public CommodityType Type { get; set; }

    public string Cusip { get; set; } = null!;

    public int Precision { get; set; }
}
