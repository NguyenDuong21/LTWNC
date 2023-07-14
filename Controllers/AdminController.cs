using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using Cafe_Management_System.Models;
using Microsoft.EntityFrameworkCore;
using System.IO;
using System.Text;
using System.Data.SqlClient;
using System.Security.Cryptography;
using Microsoft.Extensions.Configuration;
using Microsoft.AspNetCore.Http;
namespace Cafe_Management_System.Controllers;

public class AdminController : Controller
{
    private readonly ILogger<AdminController> _logger;
    private readonly dbContext _context;
    private string email;
    public AdminController(ILogger<AdminController> logger, dbContext context)
    {
        _logger = logger;
        _context = context;
        
    }

    public IActionResult Index()
    {
        email = HttpContext.Session.GetString("_Email");
        return email != null ? View() : RedirectToAction("Login");
    }

    [HttpGet("/login")]
    public async Task<IActionResult> Login()
    {
        email = HttpContext.Session.GetString("_Email");
        return email == null ? View() : RedirectToAction("Index");
    }
    [HttpPost("/login")]
    public async Task<IActionResult> LoginHandle(Account account)
    {
        string emailLogin = account.Email;
        ViewData["isLoginSuccess"] = "Tài khoản hoặc mật khẩu không chính xác";
        Account loginAccount = await _context.tblAccount.FindAsync(emailLogin);
        if(loginAccount != null) {
            string password = loginAccount.PassWord;
            if (password == Encrypt(account.PassWord)) {
                HttpContext.Session.SetString("_Email", emailLogin);
                return RedirectToRoute("AdminPage");
            }
        }
        return View("~/Views/Admin/Login.cshtml");
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
