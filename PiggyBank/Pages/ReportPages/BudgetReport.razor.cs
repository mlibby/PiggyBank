namespace PiggyBank.Pages.ReportPages;

public partial class BudgetReport
{
    [Inject] private AccountService AccountService { get; set; } = default!;
    [Inject] private BudgetService BudgetService { get; set; } = default!;

    private const string s_actualBalance = "actual";
    private const string s_budgetBalance = "budget";

    private bool _loading = true;

    private ICollection<Account>? _accounts;
    private Dictionary<string, Balances>? _balances;
    private Budget? _budget = null;
    private ICollection<Budget>? _budgets = null;
    private DateOnly _startDate = DateOnly.MinValue;
    private DateOnly _endDate = DateOnly.MaxValue;
    private Guid _budgetId = Guid.Empty;
    private Guid BudgetId
    {
        get => _budgetId;
        set
        {
            _budgetId = value;
            SelectBudget();
        }
    }

    protected override async Task OnInitializedAsync()
    {
        _loading = true;

        var endDate = DateTime.Now;
        _endDate = DateOnly.FromDateTime(endDate);
        _startDate = new DateOnly(_endDate.Year, 1, 1);

        _accounts = await AccountService.GetAccountsIncludeSplitsAsync();
        _budgetId = await BudgetService.GetDefaultBudgetIdAsync();
        if (_budgetId == Guid.Empty)
        {
            _budgets = await BudgetService.GetBudgetsAsync();
        }
        else
        {
            LoadBudget();
        }

        _loading = false;
    }

    protected void LoadBudget()
    {
        if (_budgetId == Guid.Empty)
        {
            return;
        }

        _budget = BudgetService.GetBudgetAndAmounts(_budgetId);

        if (_budget is null || _accounts is null)
        {
            return;
        }

        _balances = new()
        {
            [s_actualBalance] = new Balances(_accounts, _startDate, _endDate),
            [s_budgetBalance] = new Balances(_accounts, _budget, _startDate, _endDate)
        };
    }

    protected void SelectBudget()
    {
        if (_budgetId == Guid.Empty)
        {
            return;
        }

        BudgetService.SaveDefaultBudgetId(_budgetId);
        LoadBudget();
    }

    protected TreeTableModel CreateTreeTableModel(Account.AccountType accountType)
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

    protected void AddAccountsToModel(Account account, TreeTableModel model, TreeTableNodeModel? parent = null)
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

    private Account? GetRootAccount(Account.AccountType accountType)
        => _accounts?.SingleOrDefault(a => a.Parent == null && a.Type == accountType);
}
