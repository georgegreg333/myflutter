using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using WasteTrackerAPI.Models;

namespace WasteTrackerAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TrackWasteController : ControllerBase
    {
        private readonly WastedbContext _context;

        // Constructor that injects WastedbContext
        public TrackWasteController(WastedbContext context)
        {
            _context = context;
        }

        // GET: api/TrackWaste
        [HttpGet]
        public async Task<ActionResult<IEnumerable<TrackWaste>>> GetTrackWaste()
        {
            // Query all track waste records from the database
            var trackWastes = await _context.Trackwastes.ToListAsync();

            // Return the records in the response with a status of 200 OK
            return Ok(trackWastes);
        }

        // Optional: Fetch a specific track waste record by ID
        [HttpGet("{id}")]
        public async Task<ActionResult<TrackWaste>> GetTrackWasteById(int id)
        {
            // Query a single track waste record by its ID
            var trackWaste = await _context.Trackwastes.FindAsync(id);

            if (trackWaste == null)
            {
                return NotFound(); // If not found, return 404 Not Found
            }

            // Return the specific track waste record with a status of 200 OK
            return Ok(trackWaste);
        }
    }
}