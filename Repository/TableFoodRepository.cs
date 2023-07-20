using Cafe_Management_System.Interface;
using Cafe_Management_System.Models;

namespace Cafe_Management_System.Repository;
public class TableFoodRepository : RepositoryBase<TableFood>, ITableFoodRepository
{
    public TableFoodRepository(RepositoryContext repositoryContext)
        :base(repositoryContext)
    {
    }
    
}