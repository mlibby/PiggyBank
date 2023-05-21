namespace PiggyBank.Shared.TreeView;

public partial class TreeView
{
    [Parameter]
    public ICollection<TreeViewModel>? Model { get; set; }
}
