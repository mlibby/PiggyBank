namespace PiggyBank.Data.Models;

public partial class BudgetAmount
{
    public class Configuration
    {
        public DateHelper.PeriodType DefaultPeriod { get; set; }

        public DateOnly StartDate { get; set; } = DateOnly.MinValue;
        public DateOnly EndDate { get; set; } = DateOnly.MaxValue;

        public int RoundTo { get; set; } = 0;

        public List<AccountType> AccountTypes { get; set; } = new List<AccountType>();
    }
}
