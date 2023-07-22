using Cafe_Management_System.Interface;
using Cafe_Management_System.Models;

namespace Cafe_Management_System.Repository;
public class BillInfoRepository : RepositoryBase<BillInfo>, IBillInfoRepository
{
    public BillInfoRepository(RepositoryContext repositoryContext)
        :base(repositoryContext)
    {
    }
    
}