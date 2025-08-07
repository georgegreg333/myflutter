using Microsoft.EntityFrameworkCore; // Required namespace for Entity Framework Core functionality
using MyApi; // This namespace contains AppDbContext and other domain classes

// Create a WebApplication builder to configure services and the app pipeline
var builder = WebApplication.CreateBuilder(args);

// ============================
// Configure Services Section
// ============================
// Add a CORS policy named "AllowAll"
// This allows requests from any origin, with any method and any header
// CORS Configuration: Set up a permissive CORS policy (AllowAll) and apply it before routing.
// This is important for frontend-backend communication in web applications.
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy
            .AllowAnyOrigin() // Allow requests from any domain (not secure for production)
            .AllowAnyHeader() // Allow any HTTP header
            .AllowAnyMethod(); // Allow any HTTP methods (GET, POST, etc.)  
    });
});

// Register AppDbContext with MySQL connection string
// Using MySQL as the database provider
// Registering AppDbContext using the correct UseMySQL method.
// This ensures EF Core will use a MySQL provider for data access.
// EF stands for Entity Framework, which is an Object-Relational Mapper (ORM) provided by Microsoft for .NET applications.
// Entity Framework helps developers interact with a database using .NET objects
// instead of writing raw SQL queries. It maps database tables to C# classes and table rows to objects,
// making it easier to work with data.

builder.Services.AddDbContext<AppDbContext>(options =>
    //options.UseMySQL(builder.Configuration.GetConnectionString("DefaultConnection")));
    options.UseMySQL("server=localhost;database=mydb;user=root;password=George3####"));

// Add support for controllers (enables MVC-style endpoints)
// Register controllers
builder.Services.AddControllers();

// ============================
// Configure HTTP Request Pipeline
// ============================
var app = builder.Build();

// Enable CORS using the previously defined "AllowAll" policy
app.UseCors("AllowAll"); // Apply CORS before routing

app.UseStaticFiles(); // allow serving files from wwwroot

// Map controller routes (enables attribute routing, e.g., [HttpGet])
// This line maps routes to controller actions that are defined using attribute routing,
// which means route information is declared directly on controller methods and classes using
// attributes like[HttpGet], [HttpPost], [Route("api/items")], etc.
// This method is essential if you're using conventional MVC-style controllers in an ASP.NET Core API project.
// With app.MapControllers() in your Program.cs, ASP.NET Core scans your controllers
// and hooks up these routes at runtime.
app.MapControllers();

//builder.WebHost.UseUrls("http://localhost:5151");
// Make backend listen on all IPs (not just localhost)
builder.WebHost.UseUrls("http://0.0.0.0:5151");

// Start the application and begin listening for HTTP requests
app.Run();
