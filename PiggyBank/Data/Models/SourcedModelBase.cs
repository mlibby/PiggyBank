namespace PiggyBank.Data.Models;

public abstract class SourceModelBase : ModelBase
{
    [Required]
    public virtual DataSource.DataSourceType Source { get; set; }
}
