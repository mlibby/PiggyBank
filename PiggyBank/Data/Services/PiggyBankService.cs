namespace PiggyBank.Data.Services;

public record PiggyBankService(PiggyBankContext Context)
{
    public async Task<ICollection<Account>> GetAccountsAsync() =>
        await Context.Accounts.Include(a => a.Commodity).ToListAsync();

    public async Task<ICollection<Account>> GetAccountsIncludeSplitsAsync() =>
        await Context.Accounts
            .Include(a => a.Commodity)
            .Include(a => a.Children)
            .Include(a => a.Splits)
            .ThenInclude(s => s.Transaction)
            .ToListAsync();

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

    public async Task<Guid> GetSettingGuidAsync(SettingType settingType)
    {
        var setting = await Context.Settings
            .SingleOrDefaultAsync(c => c.SettingType == settingType);

        if (setting is not null && Guid.TryParse(setting.Value, out Guid value))
        {
            return value;
        }

        return Guid.Empty;
    }

    public async Task<int> SaveSetting(Setting setting)
    {
        if (setting.Id == Guid.Empty)
        {
            setting.Id = Guid.NewGuid();
            Context.Settings.Add(setting);
        }
        else
        {
            Context.Entry(setting).State = EntityState.Modified;
        }

        return await Context.SaveChangesAsync();
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

    public async Task<IEnumerable<Commodity>> GetCommoditiesAsync() =>
           await Context.Commodities.ToListAsync();

    public async Task<IEnumerable<Account>> GetAccountsInTypes(IEnumerable<AccountType> accountTypes) =>
        await Context.Accounts
            .Include(a => a.Commodity)
            .Include(a => a.Splits)
            .ThenInclude(s => s.Transaction)
            .Where(a => accountTypes.Contains(a.AccountType))
            .ToListAsync();

    public async Task<IEnumerable<Transaction>> GetTransactionsAsync() =>
    await Context.Transactions.ToListAsync();
}
