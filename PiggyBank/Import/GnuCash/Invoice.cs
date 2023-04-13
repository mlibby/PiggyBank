namespace PiggyBank.Import.GnuCash;

public partial class Invoice
{
    public string Guid { get; set; } = null!;

    public string Id { get; set; } = null!;

    public string? DateOpened { get; set; }

    public string? DatePosted { get; set; }

    public string Notes { get; set; } = null!;

    public long Active { get; set; }

    public string Currency { get; set; } = null!;

    public long? OwnerType { get; set; }

    public string? OwnerGuid { get; set; }

    public string? Terms { get; set; }

    public string? BillingId { get; set; }

    public string? PostTxn { get; set; }

    public string? PostLot { get; set; }

    public string? PostAcc { get; set; }

    public long? BilltoType { get; set; }

    public string? BilltoGuid { get; set; }

    public long? ChargeAmtNum { get; set; }

    public long? ChargeAmtDenom { get; set; }
}
