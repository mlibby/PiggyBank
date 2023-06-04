namespace PiggyBank.Data.Models;

public partial class Split : SourceModelBase
{
    public Guid TransactionId { get; set; }

    public Guid AccountId { get; set; }

    [StringLength(2048)]
    public string Memo { get; set; } = null!;

    [StringLength(2048)]
    public string Action { get; set; } = null!;

    public decimal Value { get; set; }

    public decimal Quantity { get; set; }

    public virtual Account Account { get; set; } = null!;

    public virtual Transaction Transaction { get; set; } = null!;
}
