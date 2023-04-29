namespace PiggyBank.Import.GnuCash;

public partial class GncScheduledTransaction
{
    public string Guid { get; set; } = null!;

    public string? Name { get; set; }

    public long Enabled { get; set; }

    public string? StartDate { get; set; }

    public string? EndDate { get; set; }

    public string? LastOccur { get; set; }

    public long NumOccur { get; set; }

    public long RemOccur { get; set; }

    public long AutoCreate { get; set; }

    public long AutoNotify { get; set; }

    public long AdvCreation { get; set; }

    public long AdvNotify { get; set; }

    public long InstanceCount { get; set; }

    public string TemplateActGuid { get; set; } = null!;
}
