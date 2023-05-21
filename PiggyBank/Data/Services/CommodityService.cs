namespace PiggyBank.Data.Services;

public record CommodityService(PiggyBankContext Context)
{
    public async Task<IEnumerable<Commodity>> GetCommoditiesAsync() =>
        await Context.Commodities.ToListAsync();
}
