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
}