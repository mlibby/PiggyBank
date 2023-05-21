namespace PiggyBank.Shared.Notifications;

public partial class Notifications
{
    void Update(object? sender, NotifyCollectionChangedEventArgs args) => InvokeAsync(StateHasChanged);

    public void Dispose() => NotificationService.Messages.CollectionChanged -= Update;

    protected override void OnInitialized() => NotificationService.Messages.CollectionChanged += Update;
}
