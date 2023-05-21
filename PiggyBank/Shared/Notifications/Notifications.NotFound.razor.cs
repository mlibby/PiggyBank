namespace PiggyBank.Shared.Notifications;

public partial class Notifications_NotFound
{
    [Parameter]
    public string Message { get; set; } = "Could not locate resource";

}
