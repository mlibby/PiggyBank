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

        public IActionResult Index()
        {
            var accounts = _context.Accounts.ToList();
            //var accountViewModels = accounts.Select(a => new AccountViewModel(a)).ToList();
            var rootAccounts = accounts.Where(a => a.ParentId is null).OrderBy(a => a.Name).ToList();
            return View(rootAccounts);
        }
    }
}