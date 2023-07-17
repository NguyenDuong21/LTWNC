using Cafe_Management_System.Interface;
using Cafe_Management_System.Models;
using Microsoft.EntityFrameworkCore;
using System.Linq.Expressions;
namespace Cafe_Management_System.Repository;
public abstract class RepositoryBase<T> : IRepositoryBase<T> where T : class
{
    protected RepositoryContext RepositoryContext { get; set; } 
    public RepositoryBase(RepositoryContext repositoryContext) 
    {
        RepositoryContext = repositoryContext; 
    }
    public IQueryable<T> FindAll() => RepositoryContext.Set<T>().AsNoTracking();
    public IQueryable<T> FindByCondition(Expression<Func<T, bool>> expression) => 
        RepositoryContext.Set<T>().Where(expression).AsNoTracking();
    public T FindFirst(Expression<Func<T, bool>> expression) => 
        RepositoryContext.Set<T>().Where(expression).FirstOrDefault();
    public void Create(T entity) => RepositoryContext.Set<T>().Add(entity);
    public void Update(T entity) => RepositoryContext.Set<T>().Update(entity);
    public void Delete(T entity) => RepositoryContext.Set<T>().Remove(entity);
}