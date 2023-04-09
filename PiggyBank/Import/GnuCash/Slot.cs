using System;
using System.Collections.Generic;

namespace PiggyBank.Import.GnuCash;

public partial class Slot
{
    public long Id { get; set; }

    public string ObjGuid { get; set; } = null!;

    public string Name { get; set; } = null!;

    public long SlotType { get; set; }

    public long? Int64Val { get; set; }

    public string? StringVal { get; set; }

    public double? DoubleVal { get; set; }

    public string? TimespecVal { get; set; }

    public string? GuidVal { get; set; }

    public long? NumericValNum { get; set; }

    public long? NumericValDenom { get; set; }

    public string? GdateVal { get; set; }
}
