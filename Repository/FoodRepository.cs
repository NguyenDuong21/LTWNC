using Cafe_Management_System.Interface;
using Cafe_Management_System.Models;

namespace Cafe_Management_System.Repository;
public class FoodRepository : RepositoryBase<Food>, IFoodRepository
{
    public FoodRepository(RepositoryContext repositoryContext)
        :base(repositoryContext)
    {
    }
    
}