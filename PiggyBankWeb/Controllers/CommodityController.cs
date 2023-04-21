﻿namespace PiggyBankWeb.Controllers
{
    public class CommodityController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly IPiggyBankContext _context;

        public CommodityController(ILogger<HomeController> logger, PiggyBankContext context)
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