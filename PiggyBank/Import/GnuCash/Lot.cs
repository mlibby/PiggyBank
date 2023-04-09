using System;
using System.Collections.Generic;

namespace PiggyBank.Import.GnuCash;

public partial class Lot
{
    public string Guid { get; set; } = null!;

    public string? AccountGuid { get; set; }

    public long IsClosed { get; set; }
}
