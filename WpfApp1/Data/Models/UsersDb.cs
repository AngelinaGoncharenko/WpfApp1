using System;
using System.Collections.Generic;

namespace WpfApp1.Data.Models;

public partial class UsersDb
{
    public int UserId { get; set; }

    public string? LoginName { get; set; }

    public string? PasswordName { get; set; }

    public virtual ICollection<TestDatum> TestData { get; set; } = new List<TestDatum>();
}
