using Cafe_Management_System.Interface;
using Cafe_Management_System.Models;

namespace Cafe_Management_System.Repository;
public class CategoryRepository : RepositoryBase<Category>, ICategoryRepository
{
    public CategoryRepository(RepositoryContext repositoryContext)
        :base(repositoryContext)
    {
    }
    
}