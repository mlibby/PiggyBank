namespace PiggyBank.Data.Services
{
    public class BudgetService
    {
        private readonly PiggyBankContext _context;

        public BudgetService(PiggyBankContext context) => _context = context;

        public async Task<int> GetBudgetAmountCountAsync(Guid budgetId)
        {
            return await _context.BudgetAmounts.CountAsync(ba => ba.BudgetId == budgetId);
        }

        public async Task<ICollection<Budget>> GetBudgetsAsync()
        {
            return await _context.Budgets.ToListAsync();
        }

        public async Task<Budget?> GetBudgetAsync(Guid id)
        {
            return await _context.Budgets.FindAsync(id);
        }

        public async Task<int> Save(Budget budget)
        {
            if (budget.Id == Guid.Empty)
            {
                budget.Id = Guid.NewGuid();
                _context.Budgets.Add(budget);
            }
            else
            {
                _context.Entry(budget).State = EntityState.Modified;
            }

            return await _context.SaveChangesAsync();
        }

        public async Task CalculateAmounts(Budget budget, BudgetAmount.Configuration config)
        {
            var accounts = await _context.Accounts
                .Include(a => a.Splits)
                .ThenInclude(s => s.Transaction)
                .Where(a => config.AccountTypes.Contains(a.Type))
                .ToListAsync();
            var amountBalances = new Balances(accounts, config.StartDate, config.EndDate);
            var periodCount = DateHelper.CalculatePeriods(config.StartDate, config.EndDate).Count;
            var budgetPeriods = DateHelper.CalculatePeriods(budget.StartDate, budget.EndDate);
            BudgetAmount.AmountType amountType = config.DefaultPeriod == DateHelper.PeriodType.Monthly ? BudgetAmount.AmountType.Monthly : BudgetAmount.AmountType.Annual;
            foreach (var account in accounts)
            {
                foreach (var period in budgetPeriods)
                {
                    budget.Amounts.Add(new BudgetAmount
                    {
                        Account = account,
                        AmountDate = period,
                        Type = amountType,
                        Value = amountBalances[account.Id] / periodCount * (int)amountType
                    }); ; ;
                }
            }
        }
    }
}