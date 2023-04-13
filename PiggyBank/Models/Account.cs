﻿using System.ComponentModel.DataAnnotations;

namespace PiggyBank.Models;

public class Account
{
    public enum Type
    {

    }

    public int Id { get; set; }
    [Required(AllowEmptyStrings = false)]
    public string? Name { get; set; }
    public Account.Type AccountType { get; set; }

}