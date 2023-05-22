namespace PiggyBank.Pages.BudgetPages;

public partial class BudgetIndex
{
    [Inject] private BudgetService BudgetService { get; set; } = default!;

    private ICollection<Budget>? _budgets;
    protected override async Task OnInitializedAsync() => _budgets = await BudgetService.GetBudgetsAsync();
}
