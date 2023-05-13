namespace PiggyBank.Shared.TreeTable;

public class TreeTableModel
{
    public List<string> Columns { get; }
    public string FirstColumn { get; } = string.Empty;

    private int? _maxDepth = null;
    public int MaxDepth
    {
        get
        {
            if (_maxDepth is not object)
            {
                _maxDepth = CalculateMaxDepth(null);
            }

            return _maxDepth.Value;
        }
    }

    public ObservableCollection<TreeTableNodeModel> Nodes { get; } = new ObservableCollection<TreeTableNodeModel>();

    public TreeTableModel(string firstColumn, List<string> columns)
    {
        FirstColumn = firstColumn;
        Columns = columns;
        Nodes.CollectionChanged += Nodes_CollectionChanged;
    }

    private void Nodes_CollectionChanged(object? sender, NotifyCollectionChangedEventArgs e)
    {
        _maxDepth = null;
    }

    public TreeTableNodeModel CreateNode(string header, List<string> values, TreeTableNodeModel? parent = null)
    {
        var node = new TreeTableNodeModel(header, values);
        node.Children.CollectionChanged += Nodes_CollectionChanged;

        if (parent is object)
        {
            parent.Children.Add(node);

        }
        else
        {
            Nodes.Add(node);
        }

        return node;
    }

    private int CalculateMaxDepth(ObservableCollection<TreeTableNodeModel>? nodes, int maxDepth = 0)
    {
        nodes = nodes ?? Nodes;
        foreach (var node in nodes)
        {
            if (node.Children.Count > 0)
            {
                var depth = CalculateMaxDepth(node.Children, maxDepth + 1);
                if (depth > maxDepth)
                {
                    maxDepth = depth;
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

