namespace PiggyBank.Models;

public partial class ExternalId
{
    public int Id { get; set; }

    public int LocalId { get; set; }

    public string ExternalIdString { get; set; } = null!;

    public SourceType Type { get; set; }

    public int Source { get; set; }
}
