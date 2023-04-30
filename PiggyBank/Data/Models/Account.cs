namespace PiggyBank.Data.Models;

public partial class Account : ModelBase
{
    public string Name { get; set; } = null!;

    public string Description { get; set; } = null!;

    public Guid? ParentId { get; set; }

    public AccountType Type { get; set; }

    public Guid CommodityId { get; set; }

    public virtual Commodity Commodity { get; set; } = null!;

    public virtual ICollection<Account> Children { get; } = new List<Account>();

    public virtual Account? Parent { get; set; }

    public bool IsHidden { get; set; } = false;

    public bool IsLocked { get; set; } = false;

    public bool IsPlaceholder { get; set; } = false;

    public virtual ICollection<Split> Splits { get; } = new List<Split>();
}
