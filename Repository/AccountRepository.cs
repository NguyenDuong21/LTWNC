using Cafe_Management_System.Interface;
using Cafe_Management_System.Models;

namespace Cafe_Management_System.Repository;
public class AccountRepository : RepositoryBase<Account>, IAccountRepository
{
    public AccountRepository(RepositoryContext repositoryContext)
        :base(repositoryContext)
    {
        
    }
    public Account GetByEmail(string email)
    {
        return FindFirst(x => x.Email.Equals(email));
    }
    public IEnumerable<Account> GetAllAccounts()
    {
        return FindAll()
            .ToList();
    }

}