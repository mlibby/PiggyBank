﻿namespace PiggyBank.Models;

public partial class Commodity : ModelBase
{
    public string Name { get; set; } = null!;

    public string? Symbol { get; set; }

    public CommodityType Type { get; set; }

    public string Cusip { get; set; } = null!;

    public int Precision { get; set; }

    public string Mnemonic { get; set; } = null!;
}