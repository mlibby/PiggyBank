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
    }
}