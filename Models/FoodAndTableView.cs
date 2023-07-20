
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Cafe_Management_System.Models;

public class FoodAndTableView
{
   public List<Food> ListFood { get; set; }
   public List<TableFood> ListTableFood { get; set; }

}
