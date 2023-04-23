namespace PiggyBankWeb.Controllers
{
    public class ReportController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly IPiggyBankContext _context;

        public ReportController(ILogger<HomeController> logger, PiggyBankContext context)
        {
            _context = context;
            _logger = logger;
        }

        public IActionResult Expense()
        {
            var startDate = new DateTime(2023, 1, 1);

            var incomeExpense = new List<Account.AccountType> { Account.AccountType.Expense, Account.AccountType.Income };
            var accounts = _context.Accounts
                .Include(a => a.Children)
                .Include(a => a.Commodity)
                .Include(a => a.Splits)
                .ThenInclude(s => s.Transaction)
                .Where(a => incomeExpense.Contains(a.Type))
                .ToList();

            var accountUtility = new AccountUtility(_context);
            var accountBalances = accountUtility.GetAccountBalances(accounts, startDate, DateTime.UtcNow);

            return View(accountBalances);
        }
    }
}
