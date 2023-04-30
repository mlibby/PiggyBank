namespace PiggyBank.Data.Import.GnuCash.Models;

public partial class GncOrder
{
    public string Guid { get; set; } = null!;

    public string Id { get; set; } = null!;

    public string Notes { get; set; } = null!;

    public string Reference { get; set; } = null!;

    public long Active { get; set; }

    public string DateOpened { get; set; } = null!;

    public string DateClosed { get; set; } = null!;

    public long OwnerType { get; set; }

    public string OwnerGuid { get; set; } = null!;
}
