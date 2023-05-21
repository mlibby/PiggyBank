namespace PiggyBank.Pages.Budget;

public partial class BudgetIndex
{
    private ICollection<Data.Models.Budget>? _budgets;
    protected override async Task OnInitializedAsync() => _budgets = await BudgetService.GetBudgetsAsync();
}
