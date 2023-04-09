using System;
using System.Collections.Generic;

namespace PiggyBank.Import.GnuCash;

public partial class Price
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
