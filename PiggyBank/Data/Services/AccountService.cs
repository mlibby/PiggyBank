namespace PiggyBank.Data.Services;

public record AccountService(PiggyBankContext Context)
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
}
