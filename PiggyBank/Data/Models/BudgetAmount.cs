namespace PiggyBank.Data.Models;

public partial class BudgetAmount : ModelBase
{
    public Guid BudgetId { get; set; }
    public virtual Budget Budget { get; set; } = null!;

    public Guid AccountId { get; set; }
    public virtual Account Account { get; set; } = null!;

    public AmountType Type { get; set; }

    public DateOnly AmountDate { get; set; }

    public Decimal Value { get; set; } = Decimal.Zero;
}
