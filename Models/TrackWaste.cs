namespace WasteTrackerAPI.Models;

public partial class TrackWaste
{
    public int Id { get; set; }

    public string Name { get; set; } = null!;

    public string? Description { get; set; }

    public string Address { get; set; } = null!;

    public DateTime Date { get; set; }

    public string? Image { get; set; }
}
