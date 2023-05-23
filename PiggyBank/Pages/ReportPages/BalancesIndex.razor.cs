namespace PiggyBank.Pages.ReportPages;

public partial class BalancesIndex
{
    [Inject] private AccountService AccountService { get; set; } = default!;

    private DateOnly _today = DateOnly.MinValue;
    private int _monthsToShow = 12;
    private List<DateOnly> _periods = new();
    private ICollection<Account>? _accounts;

    protected override async Task OnInitializedAsync()
    {
        _accounts = await AccountService.GetAccountsIncludeSplitsAsync();
        _today = DateOnly.FromDateTime(DateTime.Now);
        var currentPeriod = new DateOnly(_today.Year, _today.Month, 1);
        _periods.AddRange(DateHelper.CalculatePeriods(currentPeriod.AddMonths(-_monthsToShow), currentPeriod));
        _periods.Reverse();
    }

    protected string AccountName(object data) => ((Account)data).Name;

    protected TreeTableModel CreateTreeTableModel(Account.AccountType accountType)
    {
        var columns = _periods.Select(p => p.ToString()).ToList();
        var tableTitle = $"{accountType} Balances";
        var model = new TreeTableModel(tableTitle, "Account", columns);
        if (_accounts is null)
        {
            return model;
        }

        Dictionary<DateOnly, Balances>? balances = new();
        foreach (var period in _periods)
        {
            balances[period] = new Balances(_accounts, DateOnly.MinValue, period.AddMonths(1).AddDays(-1));
        }

        var rootAccount = GetRootAccount(accountType);
        if (rootAccount is not null)
        {
            foreach (var account in rootAccount.Children.OrderBy(c => c.Name))
            {
                AddAccountsToModel(account, model, null, balances);
            }

            //model.Footer = $"Total {rootAccount.Name}";
            //model.FooterValues.Add(rootAccount.Commodity.DisplayAmount(_balances!["YTD"][rootAccount.Id]));
            //model.FooterValues.Add(rootAccount.Commodity.DisplayAmount(_balances![_priorYear][rootAccount.Id]));
        }

        return model;
    }

    protected void AddAccountsToModel(
        Account account,
        TreeTableModel model,
        TreeTableNodeModel? parent,
        Dictionary<DateOnly, Balances> dateBalances)
    {
        List<string> balanceDisplays = new();
        foreach (var period in _periods)
        {
            if (dateBalances.TryGetValue(period, out var balances) && balances.TryGetValue(account.Id, out var balance))
            {
                balanceDisplays.Add(account.DisplayAmount(balance));
            }
            else
            {
                balanceDisplays.Add("n/a");
            }
        }

        if (!account.IsHidden)
        {
            var node = model.CreateNode(account.Name, balanceDisplays, parent);

            foreach (var childAccount in account.Children.OrderBy(a => a.Name))
            {
                AddAccountsToModel(childAccount, model, node, dateBalances);
            }
        }
    }

    private Data.Models.Account? GetRootAccount(Data.Models.Account.AccountType accountType)
        => _accounts?.SingleOrDefault(a => a.Parent == null && a.Type == accountType);
}
