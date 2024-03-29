﻿namespace PiggyBank.Data.Import.GnuCash.Models;

public partial class GncRecurrence
{
    public long Id { get; set; }

    public string ObjGuid { get; set; } = null!;

    public long RecurrenceMult { get; set; }

    public string RecurrencePeriodType { get; set; } = null!;

    public string RecurrencePeriodStart { get; set; } = null!;

    public string RecurrenceWeekendAdjust { get; set; } = null!;
}
