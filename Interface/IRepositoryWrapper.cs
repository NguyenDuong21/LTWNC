namespace Cafe_Management_System.Interface;
public interface IRepositoryWrapper
{
    IFoodRepository Food { get; }
    ICategoryRepository Category { get; }
    IAccountRepository Account { get; }
    void Save();
}