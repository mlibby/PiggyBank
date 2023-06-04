namespace PiggyBank.Data.Models;

public abstract class SourceModelBase : ModelBase
{
    [Required]
    public virtual DataSource DataSource { get; set; }

    public DateTime Updated { get; set; }
}
