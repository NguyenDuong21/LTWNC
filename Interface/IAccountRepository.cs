using Cafe_Management_System.Models;

namespace Cafe_Management_System.Interface;
public interface IAccountRepository : IRepositoryBase<Account>
{
    Account GetByEmail(string email);
    IEnumerable<Account> GetAllAccounts();
}