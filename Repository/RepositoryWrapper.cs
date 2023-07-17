using Cafe_Management_System.Interface;
using Cafe_Management_System.Models;
namespace Cafe_Management_System.Repository;
 public class RepositoryWrapper : IRepositoryWrapper
{
    private RepositoryContext _repoContext;
    private IFoodRepository _food;
    private ICategoryRepository _category;
    private IAccountRepository _account;

    public ICategoryRepository Category {
        get {
            if(_category == null)
            {
                _category = new CategoryRepository(_repoContext);
            }
            return _category;
        }
    }

    public IFoodRepository Food {
        get {
            if(_food == null)
            {
                _food = new FoodRepository(_repoContext);
            }
            return _food;
        }
    }
    public IAccountRepository Account {
        get {
            if(_account == null)
            {
                _account = new AccountRepository(_repoContext);
            }
            return _account;
        }
    }
    public RepositoryWrapper(RepositoryContext repositoryContext)
    {
        _repoContext = repositoryContext;
    }
    public void Save()
    {
        _repoContext.SaveChanges();
    }
}