using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ICommuteAPI.Data;
using ICommuteAPI.Models;

namespace ICommuteAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ActivitiesController : ControllerBase
    {
        private readonly AppDbContext _context;

        public ActivitiesController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/activities
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Activity>>> GetActivities()
        {
            return await _context.Activities.Include(a => a.User).ToListAsync();
        }

        // GET: api/activities/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Activity>> GetActivity(int id)
        {
            var activity = await _context.Activities.FindAsync(id);
            if (activity == null) return NotFound();
            return activity;
        }

        // POST: api/activities
        [HttpPost]
        public async Task<ActionResult<Activity>> CreateActivity(Activity activity)
        {
            // Check if the user exists
            var user = await _context.Users.FindAsync(activity.UserId);
            if (user == null)
            {
                return BadRequest($"User with id {activity.UserId} does not exist.");
            }

            // Only attach the foreign key; do not attempt to update the User
            activity.User = null;

            _context.Activities.Add(activity);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetActivity), new { id = activity.Id }, activity);
        }


        // PUT: api/activities/5
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateActivity(int id, Activity activity)
        {
            if (id != activity.Id) return BadRequest();
            _context.Entry(activity).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!_context.Activities.Any(a => a.Id == id)) return NotFound();
                else throw;
            }

            return NoContent();
        }

        // DELETE: api/activities/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteActivity(int id)
        {
            var activity = await _context.Activities.FindAsync(id);
            if (activity == null) return NotFound();

            _context.Activities.Remove(activity);
            await _context.SaveChangesAsync();
            return NoContent();
        }

        // GET: api/users/5/activities
        //[HttpGet("/api/users/{userId}/activities")]
        [HttpGet("user/{userId}")]
        public async Task<ActionResult<IEnumerable<Activity>>> GetUserActivities(int userId)
        {
            var activities = await _context.Activities
                .Where(a => a.UserId == userId)
                .ToListAsync();

            return activities;
        }

        // GET: api/activities/user/5/totals
        [HttpGet("user/{userId}/totals")]
        public async Task<ActionResult<object>> GetUserActivityTotals(int userId)
        {
            var userExists = await _context.Users.AnyAsync(u => u.Id == userId);
            if (!userExists)
            {
                return NotFound($"User with ID {userId} not found.");
            }

            var activities = await _context.Activities
                .Where(a => a.UserId == userId)
                .ToListAsync();

            var totalMoneySaved = activities.Sum(a => a.MoneySaved ?? 0.0);
            var totalProfit = activities.Sum(a => a.Profit ?? 0.0);

            return Ok(new
            {
                totalMoneySaved,
                totalProfit
            });
        }

    }
}
