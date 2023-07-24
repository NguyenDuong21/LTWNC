using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Cafe_Management_System.Models;

[Table("Account")]
public class Account
{
    [Key]
    public int Id { get; set; }

    [Required]
    [EmailAddress(ErrorMessage = "Invalid email format.")]
    public string Email { get; set; }

    [Required]
    public string Password { get; set; }

    [Required]
    public string Name { get; set; }

    public int Type { get; set; }

}
