namespace Cafe_Management_System.Interface;
public interface IRepositoryWrapper
{
    IFoodRepository Food { get; }
    ITableFoodRepository TableFood { get; }
    ICategoryRepository Category { get; }
    IAccountRepository Account { get; }
    // IAccountRepository Bill { get; }
    // IAccountRepository BillInfo { get; }
    void Save();
}