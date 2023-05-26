namespace PiggyBank.Data.Models;

public partial class Price : SourceModelBase
{
    public Guid CommodityId { get; set; }

    public virtual Commodity Commodity { get; set; } = null!;

    public DateOnly Date { get; set; }

    public PriceSourceType PriceSource { get; set; }

    public PriceType Type { get; set; }

    public decimal Value { get; set; }
}
