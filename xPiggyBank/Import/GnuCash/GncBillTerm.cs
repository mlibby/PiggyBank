namespace PiggyBank.Import.GnuCash;

public partial class GncBillTerm
{
    public string Guid { get; set; } = null!;

    public string Name { get; set; } = null!;

    public string Description { get; set; } = null!;

    public long Refcount { get; set; }

    public long Invisible { get; set; }

    public string? Parent { get; set; }

    public string Type { get; set; } = null!;

    public long? Duedays { get; set; }

    public long? Discountdays { get; set; }

    public long? DiscountNum { get; set; }

    public long? DiscountDenom { get; set; }

    public long? Cutoff { get; set; }
}
