using Cafe_Management_System.Interface;
using Cafe_Management_System.Models;

namespace Cafe_Management_System.Repository;
public class BillRepository : RepositoryBase<Bill>, IBillRepository
{
    public BillRepository(RepositoryContext repositoryContext)
        :base(repositoryContext)
    {
    }
    
}