﻿namespace PiggyBank.Models
{
    public partial class Configuration
    {
        public const string GnuCashDbKey = "gnucash-db";

        public static readonly List<string> ConfigurationKeys = new List<string>()
        {
            GnuCashDbKey
        };
    }
}