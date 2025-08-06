using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ICommuteAPI.Models
{
    public class Activity
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public string Name { get; set; }

        [Required]
        public double Distance { get; set; }

        [Required]
        public int Time { get; set; }

        [Required]
        public string Type { get; set; }

        public int? Calories { get; set; }
        public int? Co2 { get; set; }
        public double? MoneySaved { get; set; }
        public int? Trees { get; set; }
        public int? Points { get; set; }
        public double? Profit { get; set; }

        [Required]
        public int UserId { get; set; } // foreign key

        [ForeignKey("UserId")]
        public User? User { get; set; } // navigation property
    }
}
