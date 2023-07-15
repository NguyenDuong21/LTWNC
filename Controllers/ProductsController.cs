using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using Cafe_Management_System.Models;
using Microsoft.EntityFrameworkCore;
namespace Cafe_Management_System.Controllers;

public class ProductsController : Controller
{
    private readonly IWebHostEnvironment _hostEnvironment;
    private readonly ILogger<ProductsController> _logger;

    private readonly dbContext _context;

    public ProductsController(ILogger<ProductsController> logger, dbContext context, IWebHostEnvironment hostEnvironment)
    {
        _logger = logger;
        _context = context;
        this._hostEnvironment = hostEnvironment;
    }
    [HttpGet("/product")]
    public async Task<IActionResult> Index()
    {
        var product = await _context.tblFood.ToListAsync();
        ViewData["categories"] = await _context.tblCategory.ToListAsync();
        return View(product);
    }

    [HttpPost("/handleAddProduct")]
    public async Task<IActionResult> handleSubmit(Food product)
    {
        string wwwRootPath = Path.Combine( _hostEnvironment.WebRootPath, "img", "products");
         if (!Directory.Exists(wwwRootPath))
        {
            Directory.CreateDirectory(wwwRootPath);
        }
        string fileName = Path.GetFileNameWithoutExtension(product.ImageUpload.FileName);
        string extension = Path.GetExtension(product.ImageUpload.FileName);
        product.image = fileName = fileName + DateTime.Now.ToString("yymmssfff") + extension;
        product.dateAdd = DateTime.Now;
        string path = Path.Combine(wwwRootPath, fileName);
        using (var fileStream = new FileStream(path,FileMode.Create))
        {
            await product.ImageUpload.CopyToAsync(fileStream);
        }
        //Insert record
        _context.tblFood.Add(product);
        await _context.SaveChangesAsync();
        return RedirectToAction("Index");
    }
    [HttpGet("/getProduct/{id:int?}/")]
    public async Task<IActionResult> getProduct(int id)
    {
        var product = await _context.tblFood.FindAsync(id);
        return Json(product);
    }

    [HttpPost("/handleEditProduct")]
    public async Task<IActionResult> handleEditProduct(Food product)
    {
        var productUpdate = _context.tblFood.FirstOrDefault(item => item.id == product.id);
        productUpdate.dateAdd = DateTime.Now;
        productUpdate.name = product.name;
        productUpdate.price = product.price;
        productUpdate.idCategory = product.idCategory;
        if(product.ImageUpload != null) {
            string wwwRootPath = Path.Combine( _hostEnvironment.WebRootPath, "img", "products");
            if (!Directory.Exists(wwwRootPath))
            {
                Directory.CreateDirectory(wwwRootPath);
            }
            string fileName = Path.GetFileNameWithoutExtension(product.ImageUpload.FileName);
            string extension = Path.GetExtension(product.ImageUpload.FileName);
            productUpdate.image = fileName = fileName + DateTime.Now.ToString("yymmssfff") + extension;
            
            string path = Path.Combine(wwwRootPath, fileName);

            using (var fileStream = new FileStream(path,FileMode.Create))
            {
                await product.ImageUpload.CopyToAsync(fileStream);
            }
            //Insert record
        }
        _context.tblFood.Update(productUpdate);
        await _context.SaveChangesAsync();
        return RedirectToAction("Index");
    }

    [HttpPost("/handleDeleteProduct")]
    public async Task<IActionResult> handleDeleteProduct(int id)
    {
        Console.WriteLine(id);
        try
        {
            var product = await _context.tblFood.FindAsync(id);
            _context.tblFood.Remove(product);
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
