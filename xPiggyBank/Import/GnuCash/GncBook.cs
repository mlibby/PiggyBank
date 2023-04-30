namespace PiggyBank.Data.Import.GnuCash;

public partial class GncBook
{
    public string Guid { get; set; } = null!;

    public string RootAccountGuid { get; set; } = null!;

    public string RootTemplateGuid { get; set; } = null!;
}
