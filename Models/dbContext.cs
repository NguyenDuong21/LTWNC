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


}
