using System;
using System.Collections.Generic;

namespace PiggyBank.Import.GnuCash;

public partial class Account
{
    public string Guid { get; set; } = null!;

    public string Name { get; set; } = null!;

    public string AccountType { get; set; } = null!;

    public string? CommodityGuid { get; set; }

    public long CommodityScu { get; set; }

    public long NonStdScu { get; set; }

    public string? ParentGuid { get; set; }

    public string? Code { get; set; }

    public string? Description { get; set; }

    public long? Hidden { get; set; }

    public long? Placeholder { get; set; }
}
