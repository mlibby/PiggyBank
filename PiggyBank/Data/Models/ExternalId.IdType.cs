namespace PiggyBank.Data.Models;

public partial class ExternalId
{
    public enum IdType
    {
        Account = 1,
        Commodity = 2,
        Transaction = 3
    };
}

