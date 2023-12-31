using Microsoft.EntityFrameworkCore;
namespace Cafe_Management_System.Models;

public partial class dbContext : DbContext
{
    public dbContext()
    {

    }
    protected override void OnModelCreating(ModelBuilder builder)
    {
        builder.Entity<Bill>().ToTable(tb => tb.HasTrigger("tg_bill"));
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
