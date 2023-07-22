using Microsoft.EntityFrameworkCore;
namespace Cafe_Management_System.Models;

public partial class dbContext : DbContext
{
    public dbContext()
    {

    }
    public dbContext(DbContextOptions<dbContext> options)
        : base(options)
    {

    }
    public DbSet<Account> tblAccount { get; set; }
    public DbSet<Category> tblCategory { get; set; }
    public DbSet<Food> tblFood { get; set; }
    public DbSet<TableFood>? TableFoods { get; set; }
    public DbSet<Bill>? Bills { get; set; }
    public DbSet<BillInfo>? billInfos { get; set; }
}
