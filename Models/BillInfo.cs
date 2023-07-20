
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Cafe_Management_System.Models;

[Table("BillInfo")]
public class BillInfo
{
    [Key]
    public int id { get; set; }
    public int idBill { get; set; }

    public int idFood { get; set; }
    
    public int count { get; set; }

}
