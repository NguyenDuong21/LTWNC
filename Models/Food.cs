
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Cafe_Management_System.Models;

[Table("Food")]
public class Food
{
    [Key]
    public int id { get; set; }
    public string name { get; set; }

    public int idCategory { get; set; }
    
    public double price { get; set; }
    
    public string? image { get; set; }

    public DateTime? dateAdd { get; set; }
    
    [NotMapped]
    public IFormFile ImageUpload { get; set; }

}
