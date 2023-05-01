namespace PiggyBank.Data.Services
{
    public class CommodityService
    {
        private PiggyBankContext _context;

        public CommodityService(PiggyBankContext context) => _context = context;

        public async Task<IEnumerable<Commodity>> GetCommoditiesAsync()
        {
            return await _context.Commodities.ToListAsync();
        }
    }
}