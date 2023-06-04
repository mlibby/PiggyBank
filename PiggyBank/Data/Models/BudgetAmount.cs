namespace PiggyBank.Data.Models;

public partial class BudgetAmount : ModelBase
{
    public Guid BudgetId { get; set; }
    public virtual Budget Budget { get; set; } = null!;

    public Guid AccountId { get; set; }
    public virtual Account Account { get; set; } = null!;

    public AmountType AmountType { get; set; }

    public DateOnly AmountDate { get; set; }

    public decimal Value { get; set; } = decimal.Zero;
}
