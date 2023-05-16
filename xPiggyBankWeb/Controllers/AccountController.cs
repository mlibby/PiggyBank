namespace PiggyBankWeb.Controllers
{
    public class AccountController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly IPiggyBankContext _context;

        public AccountController(ILogger<HomeController> logger, PiggyBankContext context)
        {
            _context = context;
            _logger = logger;
        }

        public async Task<IActionResult> Index()
        {
            var accounts = await _context.Accounts.ToListAsync();
            var rootAccounts = accounts.Where(a => a.ParentId is null).OrderBy(a => a.Name);
            return View(rootAccounts);
        }

        public async Task<IActionResult> Validate()
        {
            var accounts = await _context.Accounts.ToListAsync();
            var warnings = Account.Validate(accounts);
            return View(warnings);
        }
    }
}