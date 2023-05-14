namespace PiggyBank.Data.Services
{
    public class BudgetService
    {
        private PiggyBankContext _context;

        public BudgetService(PiggyBankContext context) => _context = context;

        public async Task<ICollection<Budget>> GetBudgetsAsync()
        {
            return await _context.Budgets.ToListAsync();
        }
    }
}