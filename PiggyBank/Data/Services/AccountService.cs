namespace PiggyBank.Data.Services
{
    public class AccountService
    {
        private PiggyBankContext _context;

        public AccountService(PiggyBankContext context) => _context = context;

        public async Task<ICollection<Account>> GetAccountsAsync()
        {
            return await _context.Accounts.Include(a => a.Commodity).ToListAsync();
        }

        public async Task<ICollection<Account>> GetAccountsWithSplitsAsync()
        {
            return await _context.Accounts
                .Include(a => a.Commodity)
                .Include(a => a.Children)
                .Include(a => a.Splits)
                .ThenInclude(s => s.Transaction)
                .ToListAsync();
        }
    }
}