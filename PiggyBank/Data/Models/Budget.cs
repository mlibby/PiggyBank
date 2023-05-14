namespace PiggyBank.Data.Models;

public partial class Budget : ModelBase
{
    [Required]
    [StringLength(255)]
    public string Name { get; set; } = null!;

    [StringLength(255)]
    public string? Description { get; set; } = null;

    [Required]
    public DateOnly StartDate { get; set; }

    [Required]
    public DateOnly EndDate { get; set; }

    [Required]
    public bool IsHidden { get; set; } = false;

    public virtual ICollection<BudgetAmount> Amounts { get; } = new List<BudgetAmount>();
}
