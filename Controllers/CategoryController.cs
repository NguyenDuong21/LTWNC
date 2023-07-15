using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using Cafe_Management_System.Models;
using Microsoft.EntityFrameworkCore;
namespace Cafe_Management_System.Controllers;

public class CategoryController : Controller
{
    private readonly IWebHostEnvironment _hostEnvironment;
    private readonly ILogger<CategoryController> _logger;

    private readonly dbContext _context;

    public CategoryController(ILogger<CategoryController> logger, dbContext context, IWebHostEnvironment hostEnvironment)
    {
        _logger = logger;
        _context = context;
        this._hostEnvironment = hostEnvironment;
    }
    [HttpGet("/category")]
    public async Task<IActionResult> Index()
    {
        var categories = await _context.tblCategory.ToListAsync();
        return View(categories);
    }

    [HttpGet("/getCategory/{id:int?}/")]
    public async Task<IActionResult> getCategory(int id)
    {
        var category = await _context.tblCategory.FindAsync(id);
        return Json(category);
    }

    [HttpPost("/handleSubmit")]
    public async Task<IActionResult> handleSubmit(Category category)
    {
        string wwwRootPath = Path.Combine( _hostEnvironment.WebRootPath, "img", "categories");
         if (!Directory.Exists(wwwRootPath))
        {
            Directory.CreateDirectory(wwwRootPath);
        }
        string fileName = Path.GetFileNameWithoutExtension(category.ImageUpload.FileName);
        string extension = Path.GetExtension(category.ImageUpload.FileName);
        category.image = fileName = fileName + DateTime.Now.ToString("yymmssfff") + extension;
        category.dateAdd = DateTime.Now;
        string path = Path.Combine(wwwRootPath, fileName);
        using (var fileStream = new FileStream(path,FileMode.Create))
        {
            await category.ImageUpload.CopyToAsync(fileStream);
        }
        //Insert record
        _context.tblCategory.Add(category);
        await _context.SaveChangesAsync();
        return RedirectToAction("Index");
    }

    [HttpPost("/handleEdit")]
    public async Task<IActionResult> handleEdit(Category category)
    {
        var categoryUpdate = _context.tblCategory.FirstOrDefault(item => item.id == category.id);
        categoryUpdate.dateAdd = DateTime.Now;
        categoryUpdate.name = category.name;
        if(category.ImageUpload != null) {
            string wwwRootPath = Path.Combine( _hostEnvironment.WebRootPath, "img", "categories");
            if (!Directory.Exists(wwwRootPath))
            {
                Directory.CreateDirectory(wwwRootPath);
            }
            string fileName = Path.GetFileNameWithoutExtension(category.ImageUpload.FileName);
            string extension = Path.GetExtension(category.ImageUpload.FileName);
            categoryUpdate.image = fileName = fileName + DateTime.Now.ToString("yymmssfff") + extension;
            
            string path = Path.Combine(wwwRootPath, fileName);
            using (var fileStream = new FileStream(path,FileMode.Create))
            {
                await category.ImageUpload.CopyToAsync(fileStream);
            }
            //Insert record
        }
        _context.tblCategory.Update(categoryUpdate);
        await _context.SaveChangesAsync();
        return RedirectToAction("Index");
    }

    [HttpPost("/handleDelete")]
    public async Task<IActionResult> handleDelete(int id)
    {
        Console.WriteLine(id);
        try
        {
            var category = await _context.tblCategory.FindAsync(id);
            _context.tblCategory.Remove(category);
            await _context.SaveChangesAsync();
            return Content("success");
        }
        catch (System.Exception)
        {
            return Content("error");
            throw;
        }
        
    }

    public IActionResult Privacy()
    {
        return View();
    }

    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    public IActionResult Error()
    {
        return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
    }
}
