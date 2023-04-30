namespace PiggyBank.Data.Import.GnuCash.Models;

public partial class GncCustomer
{
    public string Guid { get; set; } = null!;

    public string Name { get; set; } = null!;

    public string Id { get; set; } = null!;

    public string Notes { get; set; } = null!;

    public long Active { get; set; }

    public long DiscountNum { get; set; }

    public long DiscountDenom { get; set; }

    public long CreditNum { get; set; }

    public long CreditDenom { get; set; }

    public string Currency { get; set; } = null!;

    public long TaxOverride { get; set; }

    public string? AddrName { get; set; }

    public string? AddrAddr1 { get; set; }

    public string? AddrAddr2 { get; set; }

    public string? AddrAddr3 { get; set; }

    public string? AddrAddr4 { get; set; }

    public string? AddrPhone { get; set; }

    public string? AddrFax { get; set; }

    public string? AddrEmail { get; set; }

    public string? ShipaddrName { get; set; }

    public string? ShipaddrAddr1 { get; set; }

    public string? ShipaddrAddr2 { get; set; }

    public string? ShipaddrAddr3 { get; set; }

    public string? ShipaddrAddr4 { get; set; }

    public string? ShipaddrPhone { get; set; }

    public string? ShipaddrFax { get; set; }

    public string? ShipaddrEmail { get; set; }

    public string? Terms { get; set; }

    public long? TaxIncluded { get; set; }

    public string? Taxtable { get; set; }
}
