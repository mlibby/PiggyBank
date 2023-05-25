namespace PiggyBank.Data.Models;

public partial class Price : SourceModelBase
{
    public Guid CommodityId { get; set; }

    public Guid CurrencyId { get; set; }

    public DateOnly Date { get; set; }

    public PriceSourceType PriceSource { get; set; }

    public PriceType Type { get; set; }

    public long ValueNumber { get; set; }

    public long ValueDenomination { get; set; }
}
