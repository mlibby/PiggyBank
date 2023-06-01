namespace PiggyBank.Data.Models;

public partial class Configuration : ModelBase
{
    public ConfigurationKey Key { get; set; }

    public string Value { get; set; } = null!;
}
