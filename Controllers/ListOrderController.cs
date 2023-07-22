using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using Cafe_Management_System.Models;
using Microsoft.EntityFrameworkCore;
using Cafe_Management_System.Interface;

namespace Cafe_Management_System.Controllers;

public class ListOrderController : Controller
{
    private readonly IWebHostEnvironment _hostEnvironment;
    private readonly ILogger<ListOrderController> _logger;

    private IRepositoryWrapper _repository;

    private readonly dbContext _context;

    public ListOrderController(ILogger<ListOrderController> logger, dbContext context, IWebHostEnvironment hostEnvironment, IRepositoryWrapper repository)
    {
        _repository = repository;
        _logger = logger;
        _context = context;
        this._hostEnvironment = hostEnvironment;
    }
    public async Task<IActionResult> Index()
    {
        var bill = _repository.Bill.FindAll().ToList();
        ViewData["tablefoods"] = await _context.TableFoods.ToListAsync();
        return View(bill);
    }
}
