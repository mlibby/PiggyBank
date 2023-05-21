namespace PiggyBank.Pages.Transaction;

public partial class ManageTransactions : IDisposable
{
    private CancellationTokenSource? _importCancellationTokenSource;
    private bool _importing;
    private int _recordCount = 0;
    private int _recordsProcessed = 0;
    private IEnumerable<Data.Models.Transaction>? _transactions;
    protected override async Task OnInitializedAsync() => _transactions = await TransactionService.GetTransactionsAsync();

    async Task ImportClicked()
    {
        _importing = true;

        var count = new Progress<int>(value => _recordCount = value);
        var processed = new Progress<int>(value => _recordsProcessed = value);
        _importCancellationTokenSource = new CancellationTokenSource();
        await ImportService.ImportTransactions(processed, count, _importCancellationTokenSource.Token);

        _transactions = await TransactionService.GetTransactionsAsync();
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
                MessageService.NotifyWarning("GnuCash transaction import cancelled");

                _importing = false;
            }
        }
    }
}
