namespace PiggyBank.Shared.TreeTable;

public class TreeTableModel
{
    public List<string> Columns { get; }
    public string FirstColumn { get; } = string.Empty;

    public string Footer { get; set; } = null!;
    public List<string> FooterValues { get; set; } = new List<string>();

    public string Title { get; } = string.Empty;

    private int? _maxDepth = null;

    public int MaxDepth
    {
        get
        {
            _maxDepth ??= CalculateMaxDepth(null);

            return _maxDepth.Value;
        }
    }

    public ObservableCollection<TreeTableNodeModel> Nodes { get; } = new ObservableCollection<TreeTableNodeModel>();

    public TreeTableModel(string title, string firstColumn, List<string> columns)
    {
        Title = title;
        FirstColumn = firstColumn;
        Columns = columns;
        Nodes.CollectionChanged += Nodes_CollectionChanged;
    }

    private void Nodes_CollectionChanged(object? sender, NotifyCollectionChangedEventArgs e) => _maxDepth = null;

    public TreeTableNodeModel CreateNode(string header, List<string> values, TreeTableNodeModel? parent = null)
    {
        var node = new TreeTableNodeModel(header, values);
        node.Children.CollectionChanged += Nodes_CollectionChanged;

        if (parent is not null)
        {
            parent.Children.Add(node);

        }
        else
        {
            Nodes.Add(node);
        }

        return node;
    }

    private int CalculateMaxDepth(ObservableCollection<TreeTableNodeModel>? nodes, int depth = 1)
    {
        var maxDepth = depth;

        nodes ??= Nodes;
        foreach (var node in nodes)
        {
            if (node.Children.Count > 0)
            {
                var childMaxDepth = CalculateMaxDepth(node.Children, depth + 1);
                if (childMaxDepth > maxDepth)
                {
                    maxDepth = childMaxDepth;
                }
            }
        }

        return maxDepth;
    }
}

public class TreeTableNodeModel
{
    public ObservableCollection<TreeTableNodeModel> Children { get; } = new ObservableCollection<TreeTableNodeModel>();
    public List<string> Values { get; }
    public string Header { get; }

    /// <summary>
    /// WARNING: do not use this constructor. Use <c>TreeTableModel.CreateNode(...)</c> instead.
    /// </summary>
    internal TreeTableNodeModel(string header, List<string> values)
    {
        Header = header;
        Values = values;
    }

    public int CountAllChildren()
    {
        var count = Children.Count;
        foreach (var node in Children)
        {
            count += node.CountAllChildren();
        }

        return count;
    }
}
