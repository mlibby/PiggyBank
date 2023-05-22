namespace PiggyBank.Pages.BudgetPages;

public partial class BudgetIndex
{
    private ICollection<Budget>? _budgets;
    protected override async Task OnInitializedAsync() => _budgets = await BudgetService.GetBudgetsAsync();
}
