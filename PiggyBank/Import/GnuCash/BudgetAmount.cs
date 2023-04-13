namespace PiggyBank.Import.GnuCash;

public partial class BudgetAmount
{
    public long Id { get; set; }

    public string BudgetGuid { get; set; } = null!;

    public string AccountGuid { get; set; } = null!;

    public long PeriodNum { get; set; }

    public long AmountNum { get; set; }

    public long AmountDenom { get; set; }
}
