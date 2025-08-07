using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace MyApi.Controllers
{
    // API controller for managing users
    // The [Route] attribute defines the route for the controller (e.g., "/User")
    [ApiController]
    [Route("[controller]")]
    public class UserController : ControllerBase
    {
        // Private read-only field for accessing the database context
        private readonly AppDbContext _context;

        // Constructor that injects the AppDbContext into the controller
        // This allows the controller to interact with the database
        public UserController(AppDbContext context)
        {
            _context = context;
        }

        // GET /User
        // This action retrieves all users from the database
        [HttpGet]
        public async Task<IActionResult> GetUsers()
        {
            try
            {
                // Asynchronously fetch all users from the database
                var users = await _context.Users.ToListAsync();
                // Return the users in an OK (200) response
                return Ok(users);
            }
            catch (Exception ex)
            {
                // If an error occurs, return a 500 status code with the error message
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        // GET /User/{id}
        // This action retrieves a user by their ID
        [HttpGet("{id}")]
        public async Task<IActionResult> GetUserById(int id)
        {
            try
            {
                // Asynchronously search for the user by their ID
                var user = await _context.Users.FindAsync(id);
                // If the user is not found, return a 404 Not Found response
                if (user == null) return NotFound();

                return Ok(user);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        // POST /User
        // This action creates a new user in the database
        [HttpPost]
        public async Task<IActionResult> CreateUser([FromBody] User user)
        {
            try
            {
                // Check if the provided user object is null
                if (user == null)
                    return BadRequest("User object is null.");

                // Validate that the user's Name is provided
                if (string.IsNullOrWhiteSpace(user.Name))
                    return BadRequest("Name is required.");

                // Add the new user to the Users DbSet
                _context.Users.Add(user);
                // Save the changes to the database asynchronously
                await _context.SaveChangesAsync();
                // Return a 201 Created response with the URI of the new resource (the user)
                // The CreatedAtAction method generates a URI for the GetUserById action
                return CreatedAtAction(nameof(GetUserById), new { id = user.Id }, user);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        // DELETE /User/{id}
        // This action deletes a user by their ID
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteUser(int id)
        {
            try
            {
                // Asynchronously search for the user by their ID
                var user = await _context.Users.FindAsync(id);
                // If the user is not found, return a 404 Not Found response
                if (user == null) return NotFound();

                // Remove the user from the Users DbSet
                _context.Users.Remove(user);
                // Save the changes to the database asynchronously
                await _context.SaveChangesAsync();

                return NoContent(); // Status code 204
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        [HttpPost("upload")]
        public async Task<IActionResult> UploadImage([FromBody] ImageUploadDto request)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(request.Name) || string.IsNullOrWhiteSpace(request.Image))
                {
                    return BadRequest(new { error = "Name and Image are required." });
                }

                // Convert the image to a byte array
                var bytes = Convert.FromBase64String(request.Image);
                var filePath = Path.Combine("wwwroot/images", $"{Guid.NewGuid()}.jpg");

                // Save the image
                await System.IO.File.WriteAllBytesAsync(filePath, bytes);

                // Create the user
                var user = new User
                {
                    Name = request.Name,  // Store the name
                    ImagePath = filePath, // Store the image path
                    Latitude = request.Latitude,
                    Longitude = request.Longitude
                };

                // Add the user to the database
                _context.Users.Add(user);
                await _context.SaveChangesAsync();

                return Ok(new { message = "User uploaded successfully", path = filePath });
            }
            catch (Exception ex)
            {
                return BadRequest(new { error = ex.Message });
            }
        }
    }
    public class ImageUploadDto
    {
        public string Image { get; set; }
        public string Name { get; set; }
        public string? Latitude { get; set; }
        public string? Longitude { get; set; }
    }
}