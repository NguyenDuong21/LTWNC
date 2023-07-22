using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using Cafe_Management_System.Models;
using Microsoft.EntityFrameworkCore;
using Cafe_Management_System.Interface;

namespace Cafe_Management_System.Controllers;

public class BillController : Controller
{
    private readonly IWebHostEnvironment _hostEnvironment;
    private readonly ILogger<BillController> _logger;

    private IRepositoryWrapper _repository;

    private readonly dbContext _context;

    public BillController(ILogger<BillController> logger, dbContext context, IWebHostEnvironment hostEnvironment, IRepositoryWrapper repository)
    {
        _repository = repository;
        _logger = logger;
        _context = context;
        this._hostEnvironment = hostEnvironment;
    }
    public async Task<IActionResult> Index()
    {
        var product = _repository.Food.FindAll().ToList();
        ViewData["tablefoods"] = await _context.TableFoods.Where(m => m.status == "Trống").ToListAsync();
        ViewData["categories"] = await _context.tblCategory.ToListAsync();
        return View(product);
    }
    [HttpPost]
    public async Task<IActionResult> AddBill()
    {
        string tableid = Request.Form["TableId"];
        string status = Request.Form["status"];
        string totalPrice = Request.Form["totalPrice"]; 

        Bill bill = new Bill();
        bill.idTable = Int32.Parse(tableid);
        bill.status = Int32.Parse(status);
        bill.totalPrice = float.Parse(totalPrice);

        _context.Bills.Add(bill);
        await _context.SaveChangesAsync();

        string array_id = Request.Form["id[]"];
        string[] ids = array_id.Split(',');
        foreach (string id in ids) 
        {
            BillInfo billInfo = new BillInfo();
            billInfo.idBill = bill.id;
            billInfo.idFood = Int32.Parse(id);
            billInfo.count = Int32.Parse(Request.Form["count[" + id + "]"]);
            _context.billInfos.Add(billInfo); //luu
            await _context.SaveChangesAsync();
        }
            var table = await _context.TableFoods.FindAsync(Int32.Parse(tableid));
            table.status="Có người";
             _context.TableFoods.Update(table);
                await _context.SaveChangesAsync();
        return View("~/Views/Bill/Success.cshtml");

    }
}
