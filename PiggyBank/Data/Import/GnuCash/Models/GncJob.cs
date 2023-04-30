namespace PiggyBank.Data.Import.GnuCash.Models;

public partial class GncJob
{
    public string Guid { get; set; } = null!;

    public string Id { get; set; } = null!;

    public string Name { get; set; } = null!;

    public string Reference { get; set; } = null!;

    public long Active { get; set; }

    public long? OwnerType { get; set; }

    public string? OwnerGuid { get; set; }
}
