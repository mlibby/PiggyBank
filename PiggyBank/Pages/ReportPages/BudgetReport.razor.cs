namespace PiggyBank.Pages.ReportPages;

public partial class BudgetReport
{
    [Inject] private AccountService AccountService { get; set; } = default!;
    [Inject] private BudgetService BudgetService { get; set; } = default!;

    private const string s_actualBalance = "actual";
    private const string s_budgetBalance = "budget";

    private bool _loading = true;
    private FormModel? _model;
    private EditContext? _editContext;
    private ValidationMessageStore? _validationMessageStore;

    private ICollection<Account>? _accounts;
    private Dictionary<string, Balances>? _balances;
    private Budget? _budget = null;


    protected override async Task OnInitializedAsync()
    {
        _loading = true;

        _accounts = await AccountService.GetAccountsIncludeSplitsAsync();

        var budgetId = await BudgetService.GetDefaultBudgetIdAsync();
        var budgets = await BudgetService.GetBudgetsAsync();
        _model = new FormModel()
        {
            BudgetId = budgetId,
            Budgets = budgets
        };

        _model.FormChanged += HandleFormChanged;

        _editContext = new EditContext(_model);
        _validationMessageStore = new ValidationMessageStore(_editContext);
        //_editContext!.OnValidationRequested += HandleValidationRequested;

        if (_model.BudgetId != Guid.Empty)
        {
            LoadBudget();
        }

        _loading = false;
    }

    private void LoadBudget()
    {
        if (_model is null || _model.BudgetId == Guid.Empty)
        {
            return;
        }

        _budget = BudgetService.GetBudgetAndAmounts(_model.BudgetId);

        if (_budget is null || _accounts is null)
        {
            return;
        }

        _balances = new()
        {
            [s_actualBalance] = new Balances(_accounts, _model.StartDate, _model.EndDate),
            [s_budgetBalance] = new Balances(_accounts, _budget, _model.StartDate, _model.EndDate)
        };
    }

    private void HandleFormChanged(object? sender, EventArgs e)
    {
        if (_model is null || _model.BudgetId == Guid.Empty)
        {
            return;
        }

        BudgetService.SaveDefaultBudgetId(_model.BudgetId);
        LoadBudget();
    }

    private TreeTableModel CreateTreeTableModel(Account.AccountType accountType)
    {
        var columns = new List<string>
        {
            "Actual YTD",
            "Budget YTD",
            "YTD Difference",
        };

        var tableTitle = $"{accountType} Actual and Budget Amounts Year to Date";
        var model = new TreeTableModel(tableTitle, "Account", columns);
        if (_accounts is null)
        {
            return model;
        }

        var rootAccount = GetRootAccount(accountType);
        if (rootAccount is not null)
        {
            foreach (var account in rootAccount.Children.OrderBy(c => c.Name))
            {
                AddAccountsToModel(account, model);
            }

            model.Footer = $"Total {rootAccount.Name}";
            model.FooterValues.Add(rootAccount.Commodity.DisplayAmount(_balances![s_actualBalance][rootAccount.Id]));
            model.FooterValues.Add(rootAccount.Commodity.DisplayAmount(_balances![s_budgetBalance][rootAccount.Id]));
            var difference = _balances![s_actualBalance][rootAccount.Id] - _balances![s_budgetBalance][rootAccount.Id];
            model.FooterValues.Add(rootAccount.Commodity.DisplayAmount(difference));
        }

        return model;
    }

    private void AddAccountsToModel(Account account, TreeTableModel model, TreeTableNodeModel? parent = null)
    {
        var difference = _balances![s_actualBalance][account.Id] - _balances![s_budgetBalance][account.Id];
        var balances = new List<string>
        {
            account.Commodity.DisplayAmount(_balances![s_actualBalance][account.Id]),
            account.Commodity.DisplayAmount(_balances![s_budgetBalance][account.Id]),
            account.Commodity.DisplayAmount(difference)
        };

        var node = model.AddNewNode(account.Name, balances, parent);
        foreach (var childAccount in account.Children.OrderBy(a => a.Name))
        {
            AddAccountsToModel(childAccount, model, node);
        }
    }

    private Account? GetRootAccount(Account.AccountType accountType) =>
        _accounts?.SingleOrDefault(a => a.Parent == null && a.Type == accountType);

    public class FormModel
    {
        public FormModel()
        {
            var endDate = DateTime.Now;
            _endDate = DateOnly.FromDateTime(endDate);
            _startDate = new DateOnly(_endDate.Year, 1, 1);
        }

        public ICollection<Budget> Budgets { get; set; } = new List<Budget>();

        private DateOnly _startDate;
        public DateOnly StartDate
        {
            get => _startDate;
            set
            {
                _startDate = value;
                OnFormChanged();
            }
        }

        private DateOnly _endDate;
        public DateOnly EndDate
        {
            get => _endDate;
            set
            {
                _endDate = value;
                OnFormChanged();
            }
        }

        private Guid _budgetId = Guid.Empty;
        public Guid BudgetId
        {
            get => _budgetId;
            set
            {
                _budgetId = value;
                OnFormChanged();
            }
        }

        public event EventHandler? FormChanged = default!;

        private void OnFormChanged() => FormChanged?.Invoke(this, EventArgs.Empty);
    }
}
