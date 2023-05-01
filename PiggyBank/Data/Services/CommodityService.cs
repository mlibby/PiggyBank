namespace PiggyBank.Data.Services
{
    public class CommodityService : ICommodityService
    {
        private IPiggyBankContext _context;

        public CommodityService(IPiggyBankContext context) => _context = context;

        public async Task<IEnumerable<Commodity>> GetCommoditiesAsync()
        {
            return await _context.Commodities.ToListAsync();
        }
    }
}