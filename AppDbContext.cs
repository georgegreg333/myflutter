using System.Threading.Channels;
using Microsoft.EntityFrameworkCore; // Required namespace for Entity Framework Core functionality

namespace MyApi // Namespace for grouping related classes in your application
{
    // AppDbContext inherits from DbContext and serves as the main EF Core data access class
    // DbContext is a class provided by EF Core that acts as a bridge between your C# code (application logic)
    // and the database. It represents a session with the database, allowing you to query and
    // save instances of your entities. Essentially, it manages the database operations and entity relationships.
    // DbContext serves as the link between your code and the database.
    // It helps manage the lifecycle of entities, generates SQL commands, and tracks changes.
    // It enables you to easily perform CRUD operations on the database without needing to write raw SQL.
    public class AppDbContext : DbContext
    {
        // Represents the "Users" table in the database
        // EF will map the User class to a Users table
        public DbSet<User> Users { get; set; }

        // Constructor that accepts DbContextOptions and passes them to the base DbContext class
        // This is required to configure the context with connection strings and provider settings
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }
    }

    // Entity class that represents a row in the "Users" table
    public class User
    {
        public int Id { get; set; } // Primary key for the User entity

        public string Name { get; set; } // Name column in the Users table

        public string? ImagePath { get; set; } // Store the image file path or URL

        public string? Latitude { get; set; }
        public string? Longitude { get; set; }
    }
}
