namespace PiggyBank.Data.Models;

public partial class BudgetAmount : ModelBase
{
    public Guid BudgetId { get; set; }

    public Guid AccountId { get; set; }

    public AmountType Type { get; set; }

    public DateOnly AmountDate { get; set; }

    public Decimal Value { get; set; } = Decimal.Zero;
}
