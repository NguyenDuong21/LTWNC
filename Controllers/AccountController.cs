using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using Cafe_Management_System.Models;
using Microsoft.EntityFrameworkCore;
using Cafe_Management_System.Interface;
using System.Text;
using System.Security.Cryptography;
using System.Text.Json;

namespace Cafe_Management_System.Controllers;

public class AccountController : Controller
{
    private readonly IWebHostEnvironment _hostEnvironment;
    private IRepositoryWrapper _repository;
    private readonly ILogger<AccountController> _logger;

    private readonly dbContext _context;

    public AccountController(ILogger<AccountController> logger, dbContext context, IWebHostEnvironment hostEnvironment, IRepositoryWrapper repository)
    {
        _repository = repository;
        _logger = logger;
        _context = context;
        this._hostEnvironment = hostEnvironment;
    }
    [HttpGet("/account")]
    public async Task<IActionResult> Index()
    {
        var accounts = _repository.Account.FindAll().ToList();
        return View(accounts);
    }
    // [HttpGet("/getAccount/{email?}/")]
    // public async Task<IActionResult> getAccount(string Email)
    // {   
    //     var account = await _context.tblAccount.FindAsync(Email);
    //     account.PassWord = Decrypt(account.PassWord);
    //     Console.WriteLine(JsonSerializer.Serialize(account));
    //     return Json(account);
    // }
    [HttpPost("/createNewAccount")]
    public async Task<IActionResult> handleSubmit(Account account)
    {
       if (ModelState.IsValid)
        {
            // Lưu tài khoản mới vào CSDL
            account.Type=0;
            account.PassWord= Encrypt(account.PassWord);
            _context.tblAccount.Add(account);
            _context.SaveChanges();
            return RedirectToAction(nameof(Index));
        }

        // Nếu ModelState không hợp lệ, quay trở lại Modal với thông tin lỗi
        return PartialView("_CreatePartial", account);
    }
     private string Encrypt(string clearText)
    {
        string encryptionKey = "MAKV2SPBNI99212";
        byte[] clearBytes = Encoding.Unicode.GetBytes(clearText);
        using (Aes encryptor = Aes.Create())
        {
            Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(encryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
            encryptor.Key = pdb.GetBytes(32);
            encryptor.IV = pdb.GetBytes(16);
            using (MemoryStream ms = new MemoryStream())
            {
                using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateEncryptor(), CryptoStreamMode.Write))
                {
                    cs.Write(clearBytes, 0, clearBytes.Length);
                    cs.Close();
                }
                clearText = Convert.ToBase64String(ms.ToArray());
            }
        }
 
        return clearText;
    }
 
    private string Decrypt(string cipherText)
    {
        string encryptionKey = "MAKV2SPBNI99212";
        byte[] cipherBytes = Convert.FromBase64String(cipherText);
        using (Aes encryptor = Aes.Create())
        {
            Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(encryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
            encryptor.Key = pdb.GetBytes(32);
            encryptor.IV = pdb.GetBytes(16);
            using (MemoryStream ms = new MemoryStream())
            {
                using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateDecryptor(), CryptoStreamMode.Write))
                {
                    cs.Write(cipherBytes, 0, cipherBytes.Length);
                    cs.Close();
                }
                cipherText = Encoding.Unicode.GetString(ms.ToArray());
            }
        }
 
        return cipherText;
    }

}
