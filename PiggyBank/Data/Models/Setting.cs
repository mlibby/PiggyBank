namespace PiggyBank.Data.Models;

public partial class Setting : ModelBase
{
    public SettingType SettingType { get; set; }

    [StringLength(4096)]
    public string Value { get; set; } = null!;
}
