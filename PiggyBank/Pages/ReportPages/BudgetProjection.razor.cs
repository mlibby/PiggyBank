namespace PiggyBank.Pages.ReportPages;

public partial class BudgetProjection
{
    private bool _loading = true;
    private FormModel? _model;
    private EditContext? _editContext;
    //private ValidationMessageStore? _validationMessageStore;

    private ICollection<Account>? _accounts;
    private Dictionary<string, Balances>? _balances;
    private List<DateOnly>? _periods;
    private string _total = "Total";
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

        var currentStartDate = new DateOnly(_model.EndDate.Year, _model.EndDate.Month, 1);
        var completedEndDate = currentStartDate.AddDays(-1);

        _balances = new();

        _periods = _budget.Amounts.Select(a => a.AmountDate).ToList().Distinct().Order().ToList();
        foreach (var periodStartDate in _periods)
        {
            var nextPeriodStartDate = periodStartDate.AddMonths(1);
            var periodEndDate = nextPeriodStartDate.AddDays(-1);
            _balances[periodStartDate.ToString()] = new Balances(_accounts, _budget, periodStartDate, periodEndDate);
        }

        var nextYearStartDate = _periods.Last().AddMonths(1);
        var yearEndDate = nextYearStartDate.AddDays(-1);

        _total = _periods.Last().Year.ToString() + " Total";
        _balances[_total] = new Balances(_accounts, _budget, _periods.First(), yearEndDate);
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
        if (_model is null || _periods is null || _balances is null)
        {
            return null;
        }

        var tableTitle = $"{accountType} Projected Budget Amounts";

        var columns = new List<string>();

        foreach (var period in _periods)
        {
            columns.Add(period.ToString());
        }
        columns.Add(_total);

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
            model.FooterValues = new List<string>();
            foreach (var period in _periods)
            {
                model.FooterValues.Add(rootAccount.Commodity.DisplayAmount(_balances[period.ToString()][rootAccount.Id], true));
            }
            model.FooterValues.Add(rootAccount.Commodity.DisplayAmount(_balances[_total][rootAccount.Id], true));
            model.Footer = $"Total {rootAccount.Name}";

        }

        return model;
    }

    private void AddAccountsToModel(Account account, TreeTableModel model, TreeTableNodeModel? parent = null)
    {
        if (_model is null || _periods is null || _balances is null)
        {
            return;
        }

        List<string> balances = new();
        foreach (var period in _periods)
        {
            balances.Add(account.Commodity.DisplayAmount(_balances[period.ToString()][account.Id], true));
        }
        balances.Add(account.Commodity.DisplayAmount(_balances[_total][account.Id], true));

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

        public event EventHandler? FormChanged = default!;

        private void OnFormChanged() => FormChanged?.Invoke(this, EventArgs.Empty);
    }
}
