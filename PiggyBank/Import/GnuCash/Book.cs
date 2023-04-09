using System;
using System.Collections.Generic;

namespace PiggyBank.Import.GnuCash;

public partial class Book
{
    public string Guid { get; set; } = null!;

    public string RootAccountGuid { get; set; } = null!;

    public string RootTemplateGuid { get; set; } = null!;
}
