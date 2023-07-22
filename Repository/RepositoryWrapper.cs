using Cafe_Management_System.Interface;
using Cafe_Management_System.Models;
namespace Cafe_Management_System.Repository;
public class RepositoryWrapper : IRepositoryWrapper
{
    private RepositoryContext _repoContext;
    private IFoodRepository _food;
    private IBillInfoRepository _billinfo;
    private IBillRepository _bill;
    private ITableFoodRepository _tablefood;
    private ICategoryRepository _category;
    private IAccountRepository _account;

    public ICategoryRepository Category
    {
        get
        {
            if (_category == null)
            {
                _category = new CategoryRepository(_repoContext);
            }
            return _category;
        }
    }
    
    public IFoodRepository Food
    {
        get
        {
            if (_food == null)
            {
                _food = new FoodRepository(_repoContext);
            }
            return _food;
        }
    }
    
    public ITableFoodRepository TableFood
    {
        get
        {
            if (_tablefood == null)
            {
                _tablefood = new TableFoodRepository(_repoContext);
            }
            return _tablefood;
        }
    }
    public IBillInfoRepository BillInfo
    {
        get
        {
            if ( _billinfo == null)
            {
                 _billinfo = new BillInfoRepository(_repoContext);
            }
            return  _billinfo;
        }
    }
    public IBillRepository Bill
    {
        get
        {
            if ( _bill == null)
            {
                 _bill = new BillRepository(_repoContext);
            }
            return  _bill;
        }
    }
    public IAccountRepository Account
    {
        get
        {
            if (_account == null)
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