namespace PiggyBank.Data.Models;

public abstract class SourceModelBase : ModelBase
{
    [Required]
    public virtual Source.SourceType Source { get; set; }
}
