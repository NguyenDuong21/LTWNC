namespace Cafe_Management_System.Interface;
public interface IRepositoryWrapper
{
    IFoodRepository Food { get; }
    ITableFoodRepository TableFood { get; }
    ICategoryRepository Category { get; }
    IAccountRepository Account { get; }
    IBillRepository Bill { get; }
    IBillInfoRepository BillInfo { get; }
    void Save();
}