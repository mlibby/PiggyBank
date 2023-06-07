namespace PiggyBank.Pages.ReportPages;

public partial class BudgetReport
{
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

        _accounts = await PiggyBankService.GetAccountsIncludeSplitsAsync();

        var budgetId = await PiggyBankService.GetSettingGuidAsync(SettingType.DefaultBudgetId);
        var budgets = await PiggyBankService.GetBudgetsAsync();
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

        _budget = PiggyBankService.GetBudgetAndAmounts(_model.BudgetId);

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

        PiggyBankService.SaveSetting(SettingType.DefaultBudgetId, _model.BudgetId.ToString());
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
                    rootAccount.Commodity.DisplayAmount(_balances![Column.ActualCurrent][rootAccount.Id], true),
                    rootAccount.Commodity.DisplayAmount(_balances![Column.BudgetCurrent][rootAccount.Id], true),
                    rootAccount.Commodity.DisplayAmount(differenceCurrent, true),
                    rootAccount.Commodity.DisplayAmount(_balances![Column.ActualYTD][rootAccount.Id], true),
                    rootAccount.Commodity.DisplayAmount(_balances![Column.BudgetYTD][rootAccount.Id], true),
                    rootAccount.Commodity.DisplayAmount(differenceYTD, true),
                };
            }
            else
            {
                var difference =
                    _balances![Column.ActualYTD][rootAccount.Id] -
                    _balances![Column.BudgetYTD][rootAccount.Id];

                model.FooterValues = new List<string>()
                {
                    rootAccount.Commodity.DisplayAmount(_balances![Column.ActualYTD][rootAccount.Id], true),
                    rootAccount.Commodity.DisplayAmount(_balances![Column.BudgetYTD][rootAccount.Id], true),
                    rootAccount.Commodity.DisplayAmount(difference, true),
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
                    account.Commodity.DisplayAmount(_balances![Column.ActualCurrent][account.Id], true),
                    account.Commodity.DisplayAmount(_balances![Column.BudgetCurrent][account.Id], true),
                    account.Commodity.DisplayAmount(differenceCurrent, true),
                    account.Commodity.DisplayAmount(_balances![Column.ActualYTD][account.Id], true),
                    account.Commodity.DisplayAmount(_balances![Column.BudgetYTD][account.Id], true),
                    account.Commodity.DisplayAmount(differenceYTD, true),
                };

        }
        else
        {
            var difference =
                _balances![Column.ActualYTD][account.Id] -
                _balances![Column.BudgetYTD][account.Id];

            balances = new List<string>
                {
                    account.Commodity.DisplayAmount(_balances![Column.ActualYTD][account.Id], true),
                    account.Commodity.DisplayAmount(_balances![Column.BudgetYTD][account.Id], true),
                    account.Commodity.DisplayAmount(difference, true)
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
