namespace PiggyBank.Pages.BudgetPages;

public partial class BudgetAmountForm
{
    [Inject] private AccountService AccountService { get; set; } = default!;
    [Inject] private BudgetService BudgetService { get; set; } = default!;
    [Inject] private NavigationManager NavigationManager { get; set; } = default!;

    [Parameter] public Guid AccountId { get; set; }
    [Parameter] public Guid BudgetId { get; set; }

    private bool _found = true;
    private bool _loading = true;
    private string _notFoundMessage = "";

    private EditContext? _editContext;
    private ValidationMessageStore? _validationMessageStore;
    private FormModel _model = new();

    protected override async Task OnParametersSetAsync()
    {
        var budget = await BudgetService.GetBudgetAccountAmountsAsync(BudgetId, AccountId);

        if (budget is null)
        {
            _notFoundMessage = $"Budget with ID '{BudgetId}' was not found";
            _found = false;
            return;
        }

        var accounts = await AccountService.GetAccountsAsync();
        _model.Load(budget, AccountId, accounts);

        _editContext = new EditContext(_model);
        _validationMessageStore = new ValidationMessageStore(_editContext);
        _editContext!.OnValidationRequested += HandleValidationRequested;

        _loading = false;
    }

    private string Action => BudgetId == Guid.Empty ? "Add" : "Edit";

    private void HandleValidationRequested(object? sender, ValidationRequestedEventArgs args)
    {
    }

    private async Task Save()
    {
        await BudgetService.Save(_model.Budget);
        Cancel();
    }

    private void Cancel() => NavigationManager.NavigateTo(PageRoute.BudgetAmountIndexFor(BudgetId));

    public class FormModel
    {
        public Budget Budget { get; set; } = new();
        public Guid AccountId { get; set; } = new();
        public ICollection<Account> Accounts { get; set; } = null!;
        public Dictionary<DateOnly, string> Amounts { get; set; } = null!;

        public void Load(Budget budget, Guid accountId, ICollection<Account> accounts)
        {
            Budget = budget;
            AccountId = accountId;
            Accounts = accounts;

            Amounts = new();
            foreach (var amount in budget.Amounts)
            {
                Amounts.Add(amount.AmountDate, amount.Account.DisplayAmount(amount.Value));
            }
        }
    }
}