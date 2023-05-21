namespace PiggyBank.Pages.Account;

public partial class ManageAccounts
{
    private bool _importing;
    private int _recordCount = 0;
    private int _recordsProcessed = 0;
    private ICollection<Data.Models.Account>? _accounts;
    protected ICollection<Data.Models.Account> RootAccounts =>
        _accounts is not null ?
        _accounts.Where(a => a.Parent == null).ToList() :
        (ICollection<Data.Models.Account>)new List<Data.Models.Account>();

    protected override async Task OnInitializedAsync() => _accounts = await AccountService.GetAccountsAsync();

    protected string AccountName(object data) => ((Data.Models.Account)data).Name;

    protected async Task Import()
    {
        _importing = true;
        var count = new Progress<int>(value => _recordCount = value);
        var processed = new Progress<int>(value => _recordsProcessed = value);
        await ImportService.ImportAccounts(processed, count, new CancellationToken());
        _accounts = await AccountService.GetAccountsAsync();
        _importing = false;
    }

    protected ICollection<TreeViewModel> AccountsToTreeViewModel(ICollection<Data.Models.Account> accounts)
    {
        var model = new List<TreeViewModel>();
        foreach (var account in accounts.OrderBy(a => a.Name))
        {
            var tvm = new TreeViewModel(new MarkupString(account.Name));
            if (account.Children.Count > 0)
            {
                tvm.Children = AccountsToTreeViewModel(account.Children);
            }

            model.Add(tvm);
        }

        return model;
    }
}
