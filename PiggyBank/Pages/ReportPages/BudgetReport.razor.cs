namespace PiggyBank.Pages.ReportPages;

public partial class BudgetReport
{
    [Inject] private BudgetService BudgetService { get; set; } = default!;

    private TreeTableModel _model;

    protected override async Task OnInitializedAsync()
    {
        var defaultBudgetId = await BudgetService.GetDefaultBudgetIdAsync();
    }

    protected string AccountName(object data) => ((Account)data).Name;

    protected TreeTableModel CreateTreeTableModel(Account.AccountType accountType)
    {
        var columns = new List<string>
        {
            "Actual YTD",
            "Budget YTD",
            "YTD Difference",
        };

        var tableTitle = $"Total Actual and Budget Amounts Year to Date";
        var model = new TreeTableModel(tableTitle, "Account", columns);
        //if (_accounts is null)
        //{
        //    return model;
        //}

        //var rootAccount = GetRootAccount(accountType);
        //if (rootAccount is not null)
        //{
        //    foreach (var account in rootAccount.Children.OrderBy(c => c.Name))
        //    {
        //        AddAccountsToModel(account, model);
        //    }

        //    model.Footer = $"Total {rootAccount.Name}";
        //    model.FooterValues.Add(rootAccount.Commodity.DisplayAmount(_balances!["YTD"][rootAccount.Id]));
        //    model.FooterValues.Add(rootAccount.Commodity.DisplayAmount(_balances![_priorYear][rootAccount.Id]));
        //}

        _model = model;
    }

    protected void AddAccountsToModel(Account account, TreeTableModel model, TreeTableNodeModel? parent = null)
    {
        //var balances = new List<string>
        //{
        //    account.Commodity.DisplayAmount(_balances!["YTD"][account.Id]),
        //    account.Commodity.DisplayAmount(_balances![_priorYear][account.Id])
        //};
        //var node = model.AddNewNode(account.Name, balances, parent);
        //foreach (var childAccount in account.Children.OrderBy(a => a.Name))
        //{
        //    AddAccountsToModel(childAccount, model, node);
        //}
    }

    //private Account? GetRootAccount(Account.AccountType accountType)
    //    => _accounts?.SingleOrDefault(a => a.Parent == null && a.Type == accountType);
}
