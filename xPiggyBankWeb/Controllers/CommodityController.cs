namespace PiggyBankWeb.Controllers
{
    public class CommodityController : Controller
    {
        private readonly ILogger<CommodityController> _logger;
        private readonly IPiggyBankContext _context;

        public CommodityController(ILogger<CommodityController> logger, PiggyBankContext context)
        {
            _context = context;
            _logger = logger;
        }

        public IActionResult Index()
        {
            var commodities = _context.Commodities.ToList();
            return View(commodities);
        }
    }
}