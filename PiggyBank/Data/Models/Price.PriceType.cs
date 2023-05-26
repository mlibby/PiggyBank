namespace PiggyBank.Data.Models;

public partial class Price
{
    public enum PriceType
    {
        Ask = 1,
        Bid = 2,
        Last = 3,
        NetAssetValue = 4,
        Transaction = 5,
        Unknown = 6,
    }
}
