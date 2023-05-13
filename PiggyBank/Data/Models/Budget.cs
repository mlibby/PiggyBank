namespace PiggyBank.Data.Models;

public partial class Budget : ModelBase
{
    public string Name { get; set; } = null!;

    public string Description { get; set; } = null!;

    public DateOnly StartDate { get; set; }

    public DateOnly EndDate { get; set; }

    public bool IsHidden { get; set; } = false;
}
