namespace PiggyBank.Models;

public partial class ExternalId
{
    public int Id { get; set; }

    public int LocalId { get; set; }

    public string ExternalIdString { get; set; } = null!;

    public IdType Type { get; set; }

    public SourceType Source { get; set; }
}
