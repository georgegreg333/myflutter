using Microsoft.EntityFrameworkCore;
using WasteTrackerAPI.Models;

var builder = WebApplication.CreateBuilder(args);

// Add CORS policy
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAllOrigins", policy =>
    {
        policy.AllowAnyOrigin()    // Allow all origins
              .AllowAnyMethod()    // Allow all HTTP methods (GET, POST, etc.)
              .AllowAnyHeader();   // Allow all headers
    });
});

// Register WastedbContext for dependency injection
builder.Services.AddDbContext<WastedbContext>(options =>
    options.UseMySQL(builder.Configuration.GetConnectionString("DefaultConnection")));

// Register controllers
builder.Services.AddControllers();

var app = builder.Build();

// Enable CORS globally
app.UseCors("AllowAllOrigins");

// Configure the HTTP request pipeline
if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
}

app.UseHttpsRedirection();
app.MapControllers();

app.Run();
