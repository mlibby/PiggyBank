namespace PiggyBank.Data.Services;

public record BudgetService(PiggyBankContext Context)
{
    public async Task<int> GetBudgetAmountCountAsync(Guid budgetId) =>
        await Context.BudgetAmounts.CountAsync(ba => ba.BudgetId == budgetId);

    public async Task<Budget?> GetBudgetAndAmountsAsync(Guid budgetId) =>
        await Context.Budgets
            .Include(b => b.Amounts)
            .ThenInclude(a => a.Account)
            .ThenInclude(a => a.Commodity)
            .SingleOrDefaultAsync(b => b.Id == budgetId);

    public async Task<ICollection<Budget>> GetBudgetsAsync() =>
        await Context.Budgets.ToListAsync();

    public async Task<Budget?> GetBudgetAsync(Guid id) =>
        await Context.Budgets.FindAsync(id);

    public async Task<int> Save(Budget budget)
    {
        if (budget.Id == Guid.Empty)
        {
            budget.Id = Guid.NewGuid();
            Context.Budgets.Add(budget);
        }
        else
        {
            Context.Entry(budget).State = EntityState.Modified;
        }

        return await Context.SaveChangesAsync();
    }

    public async Task CalculateAmounts(Budget budget, BudgetAmount.Configuration config)
    {
        var accounts = await Context.Accounts
            .Include(a => a.Splits)
            .ThenInclude(s => s.Transaction)
            .Where(a => config.AccountTypes.Contains(a.Type))
            .ToListAsync();

        var amountBalances = new Balances(accounts, config.StartDate, config.EndDate);
        var periodCount = DateHelper.CalculatePeriods(config.StartDate, config.EndDate).Count;
        var budgetPeriods = DateHelper.CalculatePeriods(budget.StartDate, budget.EndDate);
        var amountType = config.DefaultPeriod == DateHelper.PeriodType.Monthly ? BudgetAmount.AmountType.Monthly : BudgetAmount.AmountType.Annual;

        foreach (var account in accounts)
        {
            if (account.IsHidden || account.IsPlaceholder) { continue; }

            foreach (var period in budgetPeriods)
            {
                budget.Amounts.Add(new BudgetAmount
                {
                    Account = account,
                    AmountDate = period,
                    Type = amountType,
                    Value = amountBalances[account.Id] / periodCount * (int)amountType
                });
            }
        }
    }
}
