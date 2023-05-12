namespace PiggyBank.Data.Models;

public partial class Transaction : ModelBase
{
    public DateOnly PostDate { get; set; }

    public string Description { get; set; } = null!;

    public Guid CommodityId { get; set; }

    public virtual Commodity Commodity { get; set; } = null!;

    public virtual ICollection<Split> Splits { get; } = new List<Split>();
}
