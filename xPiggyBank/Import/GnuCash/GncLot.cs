namespace PiggyBank.Data.Import.GnuCash;

public partial class GncLot
{
    public string Guid { get; set; } = null!;

    public string? AccountGuid { get; set; }

    public long IsClosed { get; set; }
}
