namespace PiggyBank.Models;

public partial class Transaction : ModelBase
{
    public DateTime PostDate { get; set; }

    public DateTime EnterDate { get; set; }

    public string Description { get; set; } = null!;

    public Guid CommodityId { get; set; }

    public virtual Commodity Commodity { get; set; } = null!;

    public virtual ICollection<Split> Splits { get; } = new List<Split>();
}
