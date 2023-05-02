namespace PiggyBank.Data.Services
{
    public class TransactionService
    {
        private PiggyBankContext _context;

        public TransactionService(PiggyBankContext context) => _context = context;

        public async Task<IEnumerable<Transaction>> GetTransactionsAsync()
        {
            return await _context.Transactions.ToListAsync();
        }
    }
}