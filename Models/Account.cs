
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Cafe_Management_System.Models;

[Table("Account")]
public class Account
{
    [Key]
    public string Email { get; set; }
    public string Name { get; set; }

    public string PassWord { get; set; }
    
    public int? Type { get; set; }
    

}
