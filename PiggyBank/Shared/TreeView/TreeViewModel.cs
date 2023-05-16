using Microsoft.AspNetCore.Components;

namespace PiggyBank.Shared.TreeView
{
    public class TreeViewModel
    {
        public ICollection<TreeViewModel> Children { get; set; } = new List<TreeViewModel>();

        public MarkupString Summary { get; set; }

        public TreeViewModel(MarkupString summary) => Summary = summary;
    }
}
