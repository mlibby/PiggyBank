namespace PiggyBank.Data.Services;

public record BudgetService(PiggyBankContext Context)
{
    public async Task<int> GetBudgetAmountCountAsync(Guid budgetId) =>
        await Context.BudgetAmounts.CountAsync(ba => ba.BudgetId == budgetId);

    public Budget? GetBudgetAndAmounts(Guid budgetId) =>
        Context.Budgets
            .Include(b => b.Amounts)
            .ThenInclude(a => a.Account)
            .ThenInclude(a => a.Commodity)
            .Include(b => b.Amounts)
            .ThenInclude(a => a.Account)
            .ThenInclude(a => a.Parent)
            .SingleOrDefault(b => b.Id == budgetId);

    public async Task<Budget?> GetBudgetAndAmountsAsync(Guid budgetId) =>
        await Context.Budgets
            .Include(b => b.Amounts)
            .ThenInclude(a => a.Account)
            .ThenInclude(a => a.Commodity)
            .Include(b => b.Amounts)
            .ThenInclude(a => a.Account)
            .ThenInclude(a => a.Parent)
            .SingleOrDefaultAsync(b => b.Id == budgetId);

    public async Task<ICollection<Budget>> GetBudgetsAsync() =>
        await Context.Budgets.ToListAsync();

    public async Task<Budget?> GetBudgetAsync(Guid id) =>
        await Context.Budgets.FindAsync(id);

    public async Task<Guid> GetDefaultBudgetIdAsync()
    {
        var defaultBudget = await Context.Settings
            .SingleOrDefaultAsync(c => c.SettingType == SettingType.DefaultBudgetId);

        return defaultBudget is not null && Guid.TryParse(defaultBudget.Value, out var guid) ?
            guid :
            Guid.Empty;
    }

    public void SaveDefaultBudgetId(Guid budgetId)
    {
        var defaultBudget = Context.Settings
            .SingleOrDefault(c => c.SettingType == SettingType.DefaultBudgetId);

        if (defaultBudget is null)
        {
            defaultBudget = new Setting()
            {
                SettingType = SettingType.DefaultBudgetId
            };
            Context.Settings.Add(defaultBudget);
        }

        defaultBudget.Value = budgetId.ToString();
        Context.SaveChanges();
    }

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
        // Cannot use enums with string conversion in collections until
        // https://github.com/dotnet/efcore/issues/30921 is fixed
        var accounts = await Context.Accounts
            .Include(a => a.Commodity)
            .Include(a => a.Splits)
            .ThenInclude(s => s.Transaction)
            //.Where(a => config.AccountTypes.Contains(a.Type));
            .ToListAsync();

        var amountBalances = new Balances(accounts, config.StartDate, config.EndDate);
        var periodCount = DateHelper.CalculatePeriods(config.StartDate, config.EndDate).Count;
        var budgetPeriods = DateHelper.CalculatePeriods(budget.StartDate, budget.EndDate);
        var amountType =
            config.DefaultPeriod == DateHelper.PeriodType.Monthly ?
            AmountType.Monthly :
            AmountType.Annual;

        foreach (var account in accounts)
        {
            // TODO: remove this check when https://github.com/dotnet/efcore/issues/30921 is resolved
            if (!config.AccountTypes.Contains(account.AccountType))
            {
                continue;
            }

            if (account.IsHidden || account.IsPlaceholder)
            {
                continue;
            }

            foreach (var period in budgetPeriods)
            {
                budget.Amounts.Add(new BudgetAmount
                {
                    Account = account,
                    AmountDate = period,
                    AmountType = amountType,
                    Value = decimal.Round(amountBalances[account.Id] / periodCount * (int)amountType, config.RoundTo),
                });
            }
        }
    }
}
