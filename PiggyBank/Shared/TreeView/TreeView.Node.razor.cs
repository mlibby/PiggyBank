namespace PiggyBank.Shared.TreeView;

public partial class TreeView_Node
{
    [Parameter]
    public ICollection<TreeViewModel>? Model { get; set; }
}
