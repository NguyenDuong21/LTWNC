
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Cafe_Management_System.Models;

[Table("TableFood")]
public class TableFood
{
    [Key]
    public int id { get; set; }
    public string name { get; set; }

    public string status { get; set; }
}
