namespace PiggyBank.Models;

public partial class Account
{
    public int Id { get; set; }

    public string Name { get; set; } = null!;

    public string Description { get; set; } = null!;

    public int? ParentId { get; set; }

    public AccountType Type { get; set; }

    public int CommodityId { get; set; }

    public virtual Commodity Commodity { get; set; } = null!;

    public virtual ICollection<Account> Children { get; } = new List<Account>();

    public virtual Account? Parent { get; set; }

    public bool IsPlaceholder { get; set; } = false;

    public virtual ICollection<Split> Splits { get; } = new List<Split>();
}
