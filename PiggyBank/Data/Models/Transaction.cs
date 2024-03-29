﻿namespace PiggyBank.Data.Models;

public partial class Transaction : SourceModelBase
{
    public DateOnly PostDate { get; set; }

    public string Description { get; set; } = null!;

    public virtual ICollection<Split> Splits { get; } = new List<Split>();
}
