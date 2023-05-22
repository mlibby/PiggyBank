namespace PiggyBank.Pages.ImportPages;

public partial class GnuCash : IDisposable
{
    [Inject] private ImportService ImportService { get; set; } = default!;
    [Inject] private NotificationService NotificationService { get; set; } = default!;

    private CancellationTokenSource? _importCancellationTokenSource;
    private bool _complete;
    private bool _importing;
    private int _commodityCount;
    private int _commodityProcessed;
    private Task? _commodityImportTask;
    private int _accountCount;
    private int _accountProcessed;
    private Task? _accountImportTask;
    private int _transactionCount;
    private int _transactionProcessed;
    private Task? _transactionImportTask;

    private float AccountProgress => _accountCount == 0 ? 0 : (float)_accountProcessed / _accountCount;
    private float CommodityProgress => _commodityCount == 0 ? 0 : (float)_commodityProcessed / _commodityCount;
    private float TransactionProgress => _transactionCount == 0 ? 0 : (float)_transactionProcessed / _transactionCount;

    protected async Task Import()
    {
        if (_importing)
        {
            return;
        }

        _importing = true;

        _complete = false;
        _commodityCount = 0;
        _commodityProcessed = 0;
        _accountCount = 0;
        _accountProcessed = 0;
        _transactionCount = 0;
        _transactionProcessed = 0;

        _importCancellationTokenSource = new CancellationTokenSource();

        var count = new Progress<int>(value => { _commodityCount = value; StateHasChanged(); });
        var processed = new Progress<int>(value => { _commodityProcessed = value; StateHasChanged(); });
        _commodityImportTask = ImportService.ImportCommodities(processed, count, _importCancellationTokenSource.Token);
        await _commodityImportTask;

        count = new Progress<int>(value => { _accountCount = value; StateHasChanged(); });
        processed = new Progress<int>(value => { _accountProcessed = value; StateHasChanged(); });
        _accountImportTask = ImportService.ImportAccounts(processed, count, _importCancellationTokenSource.Token);
        await _accountImportTask;

        count = new Progress<int>(value => { _transactionCount = value; StateHasChanged(); });
        processed = new Progress<int>(value => { _transactionProcessed = value; StateHasChanged(); });
        _transactionImportTask = ImportService.ImportTransactions(processed, count, _importCancellationTokenSource.Token);
        await _transactionImportTask;

        _importing = false;
        _complete = true;
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
                NotificationService.NotifyWarning("GnuCash imports cancelled");

                _importing = false;
            }
        }
    }
}
