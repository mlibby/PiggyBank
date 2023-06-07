namespace PiggyBank.Pages.TransactionPages;

public partial class ManageTransactions : IDisposable
{
    [Inject] private ImportService ImportService { get; set; } = default!;

    private CancellationTokenSource? _importCancellationTokenSource;
    private bool _importing;
    private int _recordCount = 0;
    private int _recordsProcessed = 0;
    private IEnumerable<Transaction>? _transactions;

    protected override async Task OnInitializedAsync() => _transactions = await PiggyBankService.GetTransactionsAsync();

    async Task ImportClicked()
    {
        _importing = true;

        var count = new Progress<int>(value => _recordCount = value);
        var processed = new Progress<int>(value => _recordsProcessed = value);
        _importCancellationTokenSource = new CancellationTokenSource();
        await ImportService.ImportTransactions(processed, count, _importCancellationTokenSource.Token);

        _transactions = await PiggyBankService.GetTransactionsAsync();
        _importing = false;
    }

    public void Dispose()
    {
        Dispose(true);
        GC.SuppressFinalize(this);
    }

    protected virtual void Dispose(bool disposing)
    {
        if (disposing)
        {
            if (_importCancellationTokenSource is not null && _importing)
            {
                _importCancellationTokenSource.Cancel();
                NotificationService.NotifyWarning("GnuCash transaction import cancelled");

                _importing = false;
            }
        }
    }
}
