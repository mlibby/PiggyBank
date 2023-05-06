using Microsoft.AspNetCore.Html;

namespace PiggyBank.Shared.TreeView
{
    public class TreeViewModel
    {
        public ICollection<TreeViewModel> Children { get; set; } = new List<TreeViewModel>();

        public HtmlString Summary { get; set; }

        public TreeViewModel(HtmlString summary) => Summary = summary;
    }
}
