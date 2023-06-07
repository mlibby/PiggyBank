namespace PiggyBank.Pages.ReportPages;

public partial class BalancesIndex
{
    [Inject] private PiggyBankService AccountService { get; set; } = default!;

    private DateOnly _today = DateOnly.MinValue;
    private int _monthsToShow = 12;
    private List<DateRange>? _periodRanges = null;
    private ICollection<Account>? _accounts;

    protected override async Task OnInitializedAsync()
    {
        _accounts = await AccountService.GetAccountsIncludeSplitsAsync();
        ComputePeriods();
    }

    protected string AccountName(object data) => ((Account)data).Name;

    protected void RebuildTable()
    {
        ComputePeriods();
        StateHasChanged();
    }

    protected void ComputePeriods()
    {
        _periodRanges = null;

        _today = DateOnly.FromDateTime(DateTime.Now);
        List<DateRange> periodRanges = new();
        var currentPeriod = new DateRange(new DateOnly(_today.Year, _today.Month, 1), _today);
        periodRanges.Add(currentPeriod);
        var periods = DateHelper.CalculateDateRanges(currentPeriod.StartDate.AddMonths(-_monthsToShow), currentPeriod.StartDate);
        periods.Reverse();
        periodRanges.AddRange(periods.Where(p => p.EndDate < _today));

        _periodRanges = periodRanges;
    }

    protected TreeTableModel? CreateTreeTableModel(AccountType accountType)
    {
        if (_periodRanges is null)
        {
            return null;
        }

        var columns = _periodRanges.Select(p => p.EndDate.ToString()).ToList<string>();
        var tableTitle = $"{accountType} Balances";
        var model = new TreeTableModel(tableTitle, "Account", columns);
        if (_accounts is null)
        {
            return model;
        }

        Dictionary<DateOnly, Balances>? balances = new();
        foreach (var periodRange in _periodRanges)
        {
            balances[periodRange.EndDate] = new Balances(_accounts, DateOnly.MinValue, periodRange.EndDate);
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
        if (_periodRanges is null)
        {
            return;
        }

        List<string> balanceDisplays = new();
        foreach (var periodRange in _periodRanges)
        {
            if (dateBalances.TryGetValue(periodRange.EndDate, out var balances) && balances.TryGetValue(account.Id, out var balance))
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
            var node = model.AddNewNode(account.Name, balanceDisplays, parent);

            foreach (var childAccount in account.Children.OrderBy(a => a.Name))
            {
                AddAccountsToModel(childAccount, model, node, dateBalances);
            }
        }
    }

    private Data.Models.Account? GetRootAccount(AccountType accountType)
        => _accounts?.SingleOrDefault(a => a.Parent == null && a.AccountType == accountType);
}
