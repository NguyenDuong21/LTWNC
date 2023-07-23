using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using Cafe_Management_System.Models;
using Microsoft.EntityFrameworkCore;
using Cafe_Management_System.Interface;

namespace Cafe_Management_System.Controllers;

public class DetailOrderController : Controller
{
    private readonly IWebHostEnvironment _hostEnvironment;
    private readonly ILogger<DetailOrderController> _logger;

    private IRepositoryWrapper _repository;

    private readonly dbContext _context;

    public DetailOrderController(ILogger<DetailOrderController> logger, dbContext context, IWebHostEnvironment hostEnvironment, IRepositoryWrapper repository)
    {
        _repository = repository;
        _logger = logger;
        _context = context;
        this._hostEnvironment = hostEnvironment;
    }
    public async Task<IActionResult> Index(int id)
    {
        Console.WriteLine(id);
        var bill = await _context.billInfos.FirstOrDefaultAsync(m => m.idBill == id);
        ViewData["categories"] = await _context.tblCategory.ToListAsync();
        ViewData["foods"] = await _context.tblFood.ToListAsync();
        ViewData["bills"] = await _context.Bills.ToListAsync();
        return View(bill);
    }
    public async Task<IActionResult> Update(int id){
        try
        {
            Console.WriteLine(id);
            var bill = await _context.Bills.FindAsync(id);
            var idT = bill.idTable;
            var upD = await _context.TableFoods.Where(m=>m.id==idT).FirstOrDefaultAsync();
            upD.status = "Trống";
            bill.status = 1;
            _context.TableFoods.Update(upD);
            _context.Bills.Update(bill);
            await _context.SaveChangesAsync();
            return Content("success");
        }
        catch (System.Exception)
        {
            return Content("error");
            throw;
        }
    }
}
