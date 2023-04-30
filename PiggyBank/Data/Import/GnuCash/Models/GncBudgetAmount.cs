namespace PiggyBank.Data.Import.GnuCash.Models;

public partial class GncBudgetAmount
{
    public long Id { get; set; }

    public string BudgetGuid { get; set; } = null!;

    public string AccountGuid { get; set; } = null!;

    public long PeriodNum { get; set; }

    public long AmountNum { get; set; }

    public long AmountDenom { get; set; }
}
