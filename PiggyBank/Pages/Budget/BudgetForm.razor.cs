namespace PiggyBank.Pages.Budget;

public partial class BudgetForm
{
    [Parameter]
    public Guid BudgetId { get; set; }

    private bool _found = true;
    private string _notFoundMessage = "";
    private Data.Models.Budget? _budget;
    private EditContext? _editContext;
    private ValidationMessageStore? _validationMessageStore;
    private int _budgetAmountCount = 0;
    protected override async Task OnParametersSetAsync()
    {
        var today = DateOnly.FromDateTime(DateTime.Today);
        if (BudgetId == Guid.Empty)
        {
            var nextYear = today.Year + 1;
            _budget = new Data.Models.Budget()
            {
                Id = Guid.Empty,
                StartDate = new DateOnly(nextYear, 1, 1),
                EndDate = new DateOnly(nextYear, 12, 31),
            };
        }
        else
        {
            _budget = await BudgetService.GetBudgetAsync(BudgetId);
        }

        if (_budget is null)
        {
            _notFoundMessage = $"Budget with ID '{BudgetId}' was not found";
            _found = false;
            return;
        }

        _budgetAmountCount = await BudgetService.GetBudgetAmountCountAsync(BudgetId);
        _editContext = new EditContext(_budget);
        _validationMessageStore = new ValidationMessageStore(_editContext);
        _editContext!.OnValidationRequested += HandleValidationRequested;
    }

    private string Action => BudgetId == Guid.Empty ? "Add" : "Edit";

    private void HandleValidationRequested(object? sender, ValidationRequestedEventArgs args)
    {
        if (_budget is null)
        {
            return;
        }

        if (_validationMessageStore is null)
        {
            return;
        }

        _validationMessageStore.Clear();
        if (_budget.StartDate.Day != 1)
        {
            _validationMessageStore.Add(() => _budget.StartDate, "Budget should start on the first day of the month");
        }

        var endMonthDays = DateTime.DaysInMonth(_budget.EndDate.Year, _budget.EndDate.Month);
        if (_budget.EndDate.Day != endMonthDays)
        {
            _validationMessageStore.Add(() => _budget.EndDate, "Budget should end on the last day of the month");
        }
    }

    private async Task SaveAndCalculateAmounts()
    {
        if (_budget is null)
        {
            return;
        }

        await BudgetService.Save(_budget);
        NavigationManager.NavigateTo(PageRoute.BudgetAmountCalculateFor(_budget.Id));
    }

    private async Task SaveBudget()
    {
        if (_budget is null)
        {
            return;
        }

        await BudgetService.Save(_budget);
        Cancel();
    }

    protected void Cancel() => NavigationManager.NavigateTo(PageRoute.BudgetIndex);
}