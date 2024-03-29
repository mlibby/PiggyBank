namespace PiggyBank.Pages.AccountPages;

public partial class ManageAccounts
{
    [Inject] private ImportService ImportService { get; set; } = default!;

    private bool _importing;
    private int _recordCount = 0;
    private int _recordsProcessed = 0;
    private ICollection<Account>? _accounts;

    protected ICollection<Account> RootAccounts =>
        _accounts is not null ?
        _accounts.Where(a => a.Parent == null).ToList() :
        (ICollection<Account>)new List<Account>();

    protected override async Task OnInitializedAsync() => _accounts = await PiggyBankService.GetAccountsAsync();

    protected string AccountName(object data) => ((Account)data).Name;

    protected async Task Import()
    {
        _importing = true;
        var count = new Progress<int>(value => _recordCount = value);
        var processed = new Progress<int>(value => _recordsProcessed = value);
        await ImportService.ImportAccounts(processed, count, new CancellationToken());
        _accounts = await PiggyBankService.GetAccountsAsync();
        _importing = false;
    }

    protected ICollection<TreeViewModel> AccountsToTreeViewModel(ICollection<Account> accounts)
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
