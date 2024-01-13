namespace PiggyBank.Pages.ReportPages;

public partial class IncomeExpense
{
    private DateOnly _startDate = DateOnly.MinValue;
    private DateOnly _endDate = DateOnly.MaxValue;
    private string _priorYear = null!;
    private DateOnly _priorYearStart = DateOnly.MinValue;
    private DateOnly _priorYearEnd = DateOnly.MaxValue;
    private string _priorYear2 = null!;
    private DateOnly _priorYear2Start = DateOnly.MinValue;
    private DateOnly _priorYear2End = DateOnly.MaxValue;
    private string _priorYear3 = null!;
    private DateOnly _priorYear3Start = DateOnly.MinValue;
    private DateOnly _priorYear3End = DateOnly.MaxValue;
    private ICollection<Account>? _accounts;
    private Dictionary<string, Balances>? _balances;

    protected override async Task OnInitializedAsync()
    {
        _accounts = await PiggyBankService.GetAccountsIncludeSplitsAsync();
        var endDate = DateTime.Now;
        _endDate = DateOnly.FromDateTime(endDate);
        _startDate = new DateOnly(_endDate.Year, 1, 1);
        var ytdBalances = new Balances(_accounts, _startDate, _endDate);

        var priorYear = _endDate.Year - 1;
        _priorYear = priorYear.ToString();
        _priorYearStart = new DateOnly(priorYear, 1, 1);
        _priorYearEnd = new DateOnly(priorYear, 12, 31);

        var priorYear2 = _endDate.Year - 2;
        _priorYear2 = priorYear2.ToString();
        _priorYear2Start = new DateOnly(priorYear2, 1, 1);
        _priorYear2End = new DateOnly(priorYear2, 12, 31);

        var priorYear3 = _endDate.Year - 3;
        _priorYear3 = priorYear3.ToString();
        _priorYear3Start = new DateOnly(priorYear3, 1, 1);
        _priorYear3End = new DateOnly(priorYear3, 12, 31);


        var priorBalances = new Balances(_accounts, _priorYearStart, _priorYearEnd);
        var prior2Balances = new Balances(_accounts, _priorYear2Start, _priorYear2End);
        var prior3Balances = new Balances(_accounts, _priorYear3Start, _priorYear3End);

        _balances = new Dictionary<string, Balances>
        {
            {
                "YTD",
                ytdBalances
            },
            {
                _priorYear,
                priorBalances
            },
            {
                _priorYear2,
                prior2Balances
            },
            {
                _priorYear3,
                prior3Balances
            },
        };
    }

    protected string AccountName(object data) => ((Account)data).Name;

    protected TreeTableModel CreateTreeTableModel(AccountType accountType)
    {
        var columns = new List<string>
        {
            "YTD",
            _priorYear,
            _priorYear2,
            _priorYear3
        };
        var tableTitle = $"{accountType} Totals for Year to Date, {_priorYear}, {_priorYear2}";
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
            model.FooterValues.Add(rootAccount.Commodity.DisplayAmount(_balances![_priorYear2][rootAccount.Id]));
            model.FooterValues.Add(rootAccount.Commodity.DisplayAmount(_balances![_priorYear3][rootAccount.Id]));
        }

        return model;
    }

    protected void AddAccountsToModel(Account account, TreeTableModel model, TreeTableNodeModel? parent = null)
    {
        var balances = new List<string>
        {
            account.Commodity.DisplayAmount(_balances!["YTD"][account.Id]),
            account.Commodity.DisplayAmount(_balances![_priorYear][account.Id]),
            account.Commodity.DisplayAmount(_balances![_priorYear2][account.Id]),
            account.Commodity.DisplayAmount(_balances![_priorYear3][account.Id])
        };
        var node = model.AddNewNode(account.Name, balances, parent);
        foreach (var childAccount in account.Children.OrderBy(a => a.Name))
        {
            AddAccountsToModel(childAccount, model, node);
        }
    }

    private Account? GetRootAccount(AccountType accountType)
        => _accounts?.SingleOrDefault(a => a.Parent == null && a.AccountType == accountType);
}
