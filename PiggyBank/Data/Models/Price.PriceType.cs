namespace PiggyBank.Data.Models;

public partial class Price
{
    public enum PriceType
    {
        { "bid" | "ask" | "last" | "nav" | "transaction" | "unknown" },
    }
}
