namespace PiggyBank.Data.Import.GnuCash;

public partial class GncEntry
{
    public string Guid { get; set; } = null!;

    public string Date { get; set; } = null!;

    public string? DateEntered { get; set; }

    public string? Description { get; set; }

    public string? Action { get; set; }

    public string? Notes { get; set; }

    public long? QuantityNum { get; set; }

    public long? QuantityDenom { get; set; }

    public string? IAcct { get; set; }

    public long? IPriceNum { get; set; }

    public long? IPriceDenom { get; set; }

    public long? IDiscountNum { get; set; }

    public long? IDiscountDenom { get; set; }

    public string? Invoice { get; set; }

    public string? IDiscType { get; set; }

    public string? IDiscHow { get; set; }

    public long? ITaxable { get; set; }

    public long? ITaxincluded { get; set; }

    public string? ITaxtable { get; set; }

    public string? BAcct { get; set; }

    public long? BPriceNum { get; set; }

    public long? BPriceDenom { get; set; }

    public string? Bill { get; set; }

    public long? BTaxable { get; set; }

    public long? BTaxincluded { get; set; }

    public string? BTaxtable { get; set; }

    public long? BPaytype { get; set; }

    public long? Billable { get; set; }

    public long? BilltoType { get; set; }

    public string? BilltoGuid { get; set; }

    public string? OrderGuid { get; set; }
}
