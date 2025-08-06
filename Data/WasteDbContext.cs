using Microsoft.EntityFrameworkCore;
using WasteTrackerAPI.Models;

namespace WasteTrackerAPI.Data
{
    public class WasteDbContext : DbContext
    {
        public WasteDbContext(DbContextOptions<WasteDbContext> options) : base(options) { }

        public DbSet<TrackWaste> TrackWaste { get; set; }
    }
}
