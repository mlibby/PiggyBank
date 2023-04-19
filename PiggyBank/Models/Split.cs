namespace PiggyBank.Models;

public partial class Split : ModelBase
{
    public Guid TransactionId { get; set; }

    public Guid AccountId { get; set; }

    public string Memo { get; set; } = null!;

    public string Action { get; set; } = null!;

    public decimal Value { get; set; }

    public decimal Quantity { get; set; }

    public virtual Account Account { get; set; } = null!;

    public virtual Transaction Transaction { get; set; } = null!;
}
