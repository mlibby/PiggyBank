namespace PiggyBank.Pages.BudgetPages;

public partial class BudgetAmountForm
{
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
        var budget = await PiggyBankService.GetBudgetAndAmountsAsync(BudgetId);

        if (budget is null)
        {
            _notFoundMessage = $"Budget with ID '{BudgetId}' was not found";
            _found = false;
            return;
        }

        var accounts = await PiggyBankService.GetAccountsAsync();
        _model.Load(budget, AccountId, accounts);

        _editContext = new EditContext(_model);
        _validationMessageStore = new ValidationMessageStore(_editContext);
        _editContext!.OnValidationRequested += HandleValidationRequested;

        _loading = false;
    }

    private void HandleValidationRequested(object? sender, ValidationRequestedEventArgs args)
    {
        if (_validationMessageStore is null)
        {
            return;
        }

        if (_model.AccountId == Guid.Empty)
        {
            _validationMessageStore.Add(() => _model.AccountId, "Must select account");
        }
    }

    private async Task Save()
    {
        await PiggyBankService.Save(_model.Budget);
        Cancel();
    }

    private void Cancel() => NavigationManager.NavigateTo(PageRoute.BudgetAmountIndexFor(BudgetId));

    public class FormModel
    {
        public Budget Budget { get; set; } = new();
        public Guid AccountId { get; set; } = new();
        public Account? Account { get; set; }
        public ICollection<Account> Accounts { get; set; } = null!;
        // public Dictionary<DateOnly, decimal> Amounts { get; set; } = null!;
        public bool ShowAccountSelect { get; set; } = false;

        public void Load(Budget budget, Guid accountId, ICollection<Account> accounts)
        {
            Budget = budget;
            AccountId = accountId;
            Accounts = accounts;

            Account = Accounts.Single(a => a.Id == AccountId);
            ShowAccountSelect = AccountId == Guid.Empty;
        }
    }
}