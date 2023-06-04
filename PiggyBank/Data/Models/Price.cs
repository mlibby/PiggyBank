namespace PiggyBank.Data.Models;

public partial class Price : SourceModelBase
{
    public Guid CommodityId { get; set; }

    public virtual Commodity Commodity { get; set; } = null!;

    public DateOnly Date { get; set; }

    public PriceSource PriceSource { get; set; }

    public PriceType PriceType { get; set; }

    public decimal Value { get; set; }
}
