namespace PiggyBank.Data.Import.GnuCash;

public partial class GncBudget
{
    public string Guid { get; set; } = null!;

    public string Name { get; set; } = null!;

    public string? Description { get; set; }

    public long NumPeriods { get; set; }
}
