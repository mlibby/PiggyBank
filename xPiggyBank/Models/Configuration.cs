namespace PiggyBank.Models;

public partial class Configuration : ModelBase
{
    public string Key { get; set; } = null!;

    public string Value { get; set; } = null!;
}
