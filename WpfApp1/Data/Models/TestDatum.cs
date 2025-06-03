using System;
using System.Collections.Generic;

namespace WpfApp1.Data.Models;

public partial class TestDatum
{
    public int TestId { get; set; }

    public string? Text { get; set; }

    public int? UserId { get; set; }

    public virtual UsersDb? User { get; set; }
}
