namespace PiggyBank.Pages.ReportPages;

public partial class BalancesIndex
{
    [Inject] private AccountService AccountService { get; set; } = default!;

    private DateOnly _startDate = DateOnly.MinValue;
    private DateOnly _endDate = DateOnly.MaxValue;
    private string _priorYear = null!;
    private DateOnly _priorYearStart = DateOnly.MinValue;
    private DateOnly _priorYearEnd = DateOnly.MaxValue;
    private ICollection<Account>? _accounts;
    private Dictionary<Guid, Balances>? _balances;

    protected override async Task OnInitializedAsync()
    {
        _accounts = await AccountService.GetAccountsIncludeSplitsAsync();
        var endDate = DateTime.Now;
        _endDate = DateOnly.FromDateTime(endDate);
        _startDate = _endDate.AddYears(-1);

        _balances = new Dictionary<Guid, Balances>();

        var periods = DateHelper.CalculatePeriods(_startDate, _endDate);
        foreach (var period in periods)
        {
            var balances = new Balances(_accounts, period, period.AddMonths(1).AddDays(-1));
        }
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
            //model.FooterValues.Add(rootAccount.Commodity.DisplayAmount(_balances!["YTD"][rootAccount.Id]));
            //model.FooterValues.Add(rootAccount.Commodity.DisplayAmount(_balances![_priorYear][rootAccount.Id]));
        }

        return model;
    }

    protected void AddAccountsToModel(Data.Models.Account account, TreeTableModel model, TreeTableNodeModel? parent = null)
    {
        var balances = new List<string>
        {
            //account.Commodity.DisplayAmount(_balances!["YTD"][account.Id]),
            //account.Commodity.DisplayAmount(_balances![_priorYear][account.Id])
        };
        var node = model.CreateNode(account.Name, balances, parent);
        foreach (var childAccount in account.Children.OrderBy(a => a.Name))
        {
            AddAccountsToModel(childAccount, model, node);
        }
    }

    private Data.Models.Account? GetRootAccount(Data.Models.Account.AccountType accountType)
        => _accounts?.SingleOrDefault(a => a.Parent == null && a.Type == accountType);
}
