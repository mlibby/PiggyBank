namespace PiggyBank.Data.Services
{
    public class AccountService
    {
        private PiggyBankContext _context;

        public AccountService(PiggyBankContext context) => _context = context;

        public async Task<IEnumerable<Account>> GetAccountsAsync()
        {
            return await _context.Accounts.Include(a => a.Commodity).ToListAsync();
        }
    }
}