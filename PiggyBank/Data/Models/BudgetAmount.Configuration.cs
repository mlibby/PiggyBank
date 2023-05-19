namespace PiggyBank.Data.Models
{
    public partial class BudgetAmount
    {
        public class Configuration
        {
            public DateHelper.PeriodType DefaultPeriod { get; set; }

            public DateOnly StartDate { get; set; } = DateOnly.MinValue;
            public DateOnly EndDate { get; set; } = DateOnly.MaxValue;

            public List<Account.AccountType> AccountTypes { get; set; } = new List<Account.AccountType>();
        }
    }
}
