namespace PiggyBank.Shared.TreeTable;

public partial class TreeTable_Node
{
    [Parameter]
    public TreeTableModel? Model { get; set; }

    [Parameter]
    public ICollection<TreeTableNodeModel>? Nodes { get; set; }

    [Parameter]
    public int Depth { get; set; } = 1;

    private int DepthPlusOne => Depth + 1;
}
