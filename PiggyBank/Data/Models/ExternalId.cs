namespace PiggyBank.Data.Models;

public partial class ExternalId : ModelBase
{
    public Guid LocalId { get; set; }

    public string ExternalIdString { get; set; } = null!;

    public IdType Type { get; set; }

    public SourceType Source { get; set; }
}
