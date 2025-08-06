using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Diagnostics;

namespace ICommuteAPI.Models
{
    public class User
    {
        [Key]
        public int? Id { get; set; }

        public string Firstname { get; set; }
        public string Lastname { get; set; }

        public double TProfit { get; set; }
        public double TMoney { get; set; }

        public int Age { get; set; }
        public string Address { get; set; }
        public string Email { get; set; }

        // Initialize Activities to an empty list to avoid null errors
        public ICollection<Activity> Activities { get; set; } = new List<Activity>();
    }
}
