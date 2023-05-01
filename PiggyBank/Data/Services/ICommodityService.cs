namespace PiggyBank.Data.Services
{
    public interface ICommodityService
    {
        Task<IEnumerable<Commodity>> GetCommoditiesAsync();
    }
}