using System;
using System.Collections.Generic;

namespace PiggyBank.Import.GnuCash;

public partial class Recurrence
{
    public long Id { get; set; }

    public string ObjGuid { get; set; } = null!;

    public long RecurrenceMult { get; set; }

    public string RecurrencePeriodType { get; set; } = null!;

    public string RecurrencePeriodStart { get; set; } = null!;

    public string RecurrenceWeekendAdjust { get; set; } = null!;
}
