using System;
using System.Collections.Generic;

namespace PiggyBank.Import.GnuCash;

public partial class Budget
{
    public string Guid { get; set; } = null!;

    public string Name { get; set; } = null!;

    public string? Description { get; set; }

    public long NumPeriods { get; set; }
}
