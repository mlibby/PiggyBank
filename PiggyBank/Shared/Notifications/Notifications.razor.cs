namespace PiggyBank.Shared.Notifications;

public partial class Notifications
{
    [Inject] private NotificationService NotificationService { get; set; } = default!;

    void Update(object? sender, NotifyCollectionChangedEventArgs args) => InvokeAsync(StateHasChanged);

    public void Dispose()
    {
        Dispose(true);
        GC.SuppressFinalize(this);
    }

    protected virtual void Dispose(bool disposing)
    {
        if (disposing)
        {
            NotificationService.Messages.CollectionChanged -= Update;
        }
    }

    protected override void OnInitialized() => NotificationService.Messages.CollectionChanged += Update;
}
