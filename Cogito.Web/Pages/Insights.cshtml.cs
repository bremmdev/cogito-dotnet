using Microsoft.AspNetCore.Mvc.RazorPages;

namespace Cogito.Web.Pages;

public class InsightsModel : PageModel
{
    public int TotalEntries { get; private set; }
    public int Positive { get; private set; }
    public int Neutral { get; private set; }
    public int Negative { get; private set; }
    public int CurrentStreak { get; private set; }

    public void OnGet()
    {
        TotalEntries = 12;
        Positive = 6;
        Neutral = 4;
        Negative = 2;
        CurrentStreak = 3;
    }
}
