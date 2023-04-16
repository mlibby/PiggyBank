using System;
using System.Collections.Generic;

namespace PiggyBank.Models;

public partial class Configuration
{
    public int Id { get; set; }

    public string Key { get; set; } = null!;

    public string Value { get; set; } = null!;
}
