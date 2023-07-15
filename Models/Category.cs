
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Cafe_Management_System.Models;

[Table("FoodCategory")]
public class Category
{
    [Key]
    public int id { get; set; }
    public string name { get; set; }

    public string? image { get; set; }
    
    public DateTime? dateAdd { get; set; }
    
    [NotMapped]
    public IFormFile ImageUpload { get; set; }

}
