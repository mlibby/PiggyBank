namespace PiggyBank.Pages.ReportPages;

public partial class BudgetReport
{
    [Inject] private AccountService AccountService { get; set; } = default!;
    [Inject] private BudgetService BudgetService { get; set; } = default!;

    private enum Column
    {
        ActualYTD,
        BudgetYTD,
        ActualCurrent,
        BudgetCurrent
    }

    private bool _loading = true;
    private FormModel? _model;
    private EditContext? _editContext;
    //private ValidationMessageStore? _validationMessageStore;

    private ICollection<Account>? _accounts;
    private Dictionary<Column, Balances>? _balances;
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
        //_validationMessageStore = new ValidationMessageStore(_editContext);
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

        if (_model.ShowCompletedSeparately)
        {
            var currentStartDate = new DateOnly(_model.EndDate.Year, _model.EndDate.Month, 1);
            var completedEndDate = currentStartDate.AddDays(-1);

            _balances = new()
            {
                [Column.ActualYTD] = new Balances(_accounts, _model.StartDate, completedEndDate),
                [Column.BudgetYTD] = new Balances(_accounts, _budget, _model.StartDate, completedEndDate),
                [Column.ActualCurrent] = new Balances(_accounts, currentStartDate, _model.EndDate),
                [Column.BudgetCurrent] = new Balances(_accounts, _budget, currentStartDate, _model.EndDate)
            };
        }
        else
        {
            _balances = new()
            {
                [Column.ActualYTD] = new Balances(_accounts, _model.StartDate, _model.EndDate),
                [Column.BudgetYTD] = new Balances(_accounts, _budget, _model.StartDate, _model.EndDate)
            };
        }
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

    private TreeTableModel? CreateTreeTableModel(AccountType accountType)
    {
        if (_model is null)
        {
            return null;
        }

        var tableTitle = $"{accountType} Actual and Budget Amounts";

        var columns = new List<string>();
        if (_model.ShowCompletedSeparately)
        {
            columns.Add("Actual");
            columns.Add("Budget");
            columns.Add("Difference");

            columns.Add("Actual");
            columns.Add("Budget");
            columns.Add("Difference");
        }
        else
        {
            columns.Add("Actual YTD");
            columns.Add("Budget YTD");
            columns.Add("+/- YTD");
        };

        var model = new TreeTableModel(tableTitle, "Account", columns);

        if (_model.ShowCompletedSeparately)
        {
            model.ColumnGroups = new List<string>() { "Current", "Completed" };
            model.ColumnGroupSize = 3;
        }

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

            if (_model.ShowCompletedSeparately)
            {
                var differenceCurrent =
                    _balances![Column.ActualCurrent][rootAccount.Id] -
                    _balances![Column.BudgetCurrent][rootAccount.Id];

                var differenceYTD =
                    _balances![Column.ActualYTD][rootAccount.Id] -
                    _balances![Column.BudgetYTD][rootAccount.Id];

                model.FooterValues = new List<string>()
                {
                    rootAccount.DisplayAmount(_balances![Column.ActualCurrent][rootAccount.Id]),
                    rootAccount.DisplayAmount(_balances![Column.BudgetCurrent][rootAccount.Id]),
                    rootAccount.DisplayAmount(differenceCurrent),
                    rootAccount.DisplayAmount(_balances![Column.ActualYTD][rootAccount.Id]),
                    rootAccount.DisplayAmount(_balances![Column.BudgetYTD][rootAccount.Id]),
                    rootAccount.DisplayAmount(differenceYTD),
                };
            }
            else
            {
                var difference =
                    _balances![Column.ActualYTD][rootAccount.Id] -
                    _balances![Column.BudgetYTD][rootAccount.Id];

                model.FooterValues = new List<string>()
                {
                    rootAccount.DisplayAmount(_balances![Column.ActualYTD][rootAccount.Id]),
                    rootAccount.DisplayAmount(_balances![Column.BudgetYTD][rootAccount.Id]),
                    rootAccount.DisplayAmount(difference),
                };
            }
        }

        return model;
    }

    private void AddAccountsToModel(Account account, TreeTableModel model, TreeTableNodeModel? parent = null)
    {
        if (_model is null)
        {
            return;
        }

        List<string> balances;
        if (_model.ShowCompletedSeparately)
        {
            var differenceCurrent =
              _balances![Column.ActualCurrent][account.Id] -
              _balances![Column.BudgetCurrent][account.Id];

            var differenceYTD =
                _balances![Column.ActualYTD][account.Id] -
                _balances![Column.BudgetYTD][account.Id];

            balances = new List<string>()
                {
                    account.DisplayAmount(_balances![Column.ActualCurrent][account.Id]),
                    account.DisplayAmount(_balances![Column.BudgetCurrent][account.Id]),
                    account.DisplayAmount(differenceCurrent),
                    account.DisplayAmount(_balances![Column.ActualYTD][account.Id]),
                    account.DisplayAmount(_balances![Column.BudgetYTD][account.Id]),
                    account.DisplayAmount(differenceYTD),
                };

        }
        else
        {
            var difference =
                _balances![Column.ActualYTD][account.Id] -
                _balances![Column.BudgetYTD][account.Id];

            balances = new List<string>
                {
                    account.DisplayAmount(_balances![Column.ActualYTD][account.Id]),
                    account.DisplayAmount(_balances![Column.BudgetYTD][account.Id]),
                    account.DisplayAmount(difference)
                };
        }

        var node = model.AddNewNode(account.Name, balances, parent);
        foreach (var childAccount in account.Children.OrderBy(a => a.Name))
        {
            AddAccountsToModel(childAccount, model, node);
        }
    }

    private Account? GetRootAccount(AccountType accountType) =>
        _accounts?.SingleOrDefault(a => a.Parent == null && a.AccountType == accountType);

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

        private bool _showCompletedSeparately = false;
        public bool ShowCompletedSeparately
        {
            get => _showCompletedSeparately;
            set
            {
                _showCompletedSeparately = value;
                OnFormChanged();
            }
        }

        public event EventHandler? FormChanged = default!;

        private void OnFormChanged() => FormChanged?.Invoke(this, EventArgs.Empty);
    }
}
