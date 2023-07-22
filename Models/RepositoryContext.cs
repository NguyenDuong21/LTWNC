using Microsoft.EntityFrameworkCore;
namespace Cafe_Management_System.Models;
public class RepositoryContext: DbContext
{
    public RepositoryContext(DbContextOptions options)
        :base(options)
    {
    }
    public DbSet<Account>? Accounts { get; set; }
    public DbSet<Category>? Owners { get; set; }
    public DbSet<Food>? Foods { get; set; }
    public DbSet<TableFood>? TableFoods { get; set; }
    public DbSet<Bill>? Bills { get; set; }
    public DbSet<BillInfo>? billInfos { get; set; }

}