
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Cafe_Management_System.Models;

[Table("Bill")]
public class Bill
{
    [Key]
    public int id { get; set; }
    public int idTable { get; set; }

    public int status { get; set; }
    
    public float totalPrice { get; set; }

}
