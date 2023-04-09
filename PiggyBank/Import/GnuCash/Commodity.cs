using System;
using System.Collections.Generic;

namespace PiggyBank.Import.GnuCash;

public partial class Commodity
{
    public string Guid { get; set; } = null!;

    public string Namespace { get; set; } = null!;

    public string Mnemonic { get; set; } = null!;

    public string? Fullname { get; set; }

    public string? Cusip { get; set; }

    public long Fraction { get; set; }

    public long QuoteFlag { get; set; }

    public string? QuoteSource { get; set; }

    public string? QuoteTz { get; set; }
}
