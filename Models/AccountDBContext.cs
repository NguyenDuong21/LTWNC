using Microsoft.EntityFrameworkCore;
namespace Cafe_Management_System.Models;

public partial class AccountDBContext : DbContext
{
    public AccountDBContext()
    {

    }
    public AccountDBContext(DbContextOptions<dbContext> options)
        : base(options)
    {

    }
    public DbSet<Account> Accounts { get; set; }

}
