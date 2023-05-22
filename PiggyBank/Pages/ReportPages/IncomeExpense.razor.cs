namespace PiggyBank.Pages.ReportPages;

public partial class IncomeExpense
{
    private DateOnly _startDate = DateOnly.MinValue;
    private DateOnly _endDate = DateOnly.MaxValue;
    private string _priorYear = null!;
    private DateOnly _priorYearStart = DateOnly.MinValue;
    private DateOnly _priorYearEnd = DateOnly.MaxValue;
    private ICollection<Account>? _accounts;
    private Dictionary<string, Balances>? _balances;

    protected override async Task OnInitializedAsync()
    {
        _accounts = await AccountService.GetAccountsIncludeSplitsAsync();
        var endDate = DateTime.Now;
        _endDate = DateOnly.FromDateTime(endDate);
        _startDate = new DateOnly(_endDate.Year, 1, 1);
        var ytdBalances = new Balances(_accounts, _startDate, _endDate);
        var priorYear = _endDate.Year - 1;
        _priorYear = priorYear.ToString();
        _priorYearStart = new DateOnly(priorYear, 1, 1);
        _priorYearEnd = new DateOnly(priorYear, 12, 31);
        var priorBalances = new Balances(_accounts, _priorYearStart, _priorYearEnd);
        _balances = new Dictionary<string, Balances>
        {
            {
                "YTD",
                ytdBalances
            },
            {
                _priorYear,
                priorBalances
            }
        };
    }

    protected string AccountName(object data) => ((Account)data).Name;

    protected TreeTableModel CreateTreeTableModel(Account.AccountType accountType)
    {
        var columns = new List<string>
        {
            "YTD",
            _priorYear
        };
        var tableTitle = $"{accountType} Totals for Year to Date and {_priorYear}";
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
            model.FooterValues.Add(rootAccount.Commodity.DisplayAmount(_balances!["YTD"][rootAccount.Id]));
            model.FooterValues.Add(rootAccount.Commodity.DisplayAmount(_balances![_priorYear][rootAccount.Id]));
        }

        return model;
    }

    protected void AddAccountsToModel(Account account, TreeTableModel model, TreeTableNodeModel? parent = null)
    {
        var balances = new List<string>
        {
            account.Commodity.DisplayAmount(_balances!["YTD"][account.Id]),
            account.Commodity.DisplayAmount(_balances![_priorYear][account.Id])
        };
        var node = model.CreateNode(account.Name, balances, parent);
        foreach (var childAccount in account.Children.OrderBy(a => a.Name))
        {
            AddAccountsToModel(childAccount, model, node);
        }
    }

    private Account? GetRootAccount(Account.AccountType accountType)
        => _accounts?.SingleOrDefault(a => a.Parent == null && a.Type == accountType);
}
