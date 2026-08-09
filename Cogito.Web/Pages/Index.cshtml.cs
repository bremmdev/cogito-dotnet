using Microsoft.AspNetCore.Mvc.RazorPages;

namespace Cogito.Web.Pages;

public record Entry(int Id, string Date, string Title, string Content, string Mood, Sentiment Sentiment, string Tags, int[]? TagIds, int TotalCount);

public enum Sentiment
{
    positive,
    neutral,
    negative
}

public class EntriesModel : PageModel
{
    public List<Entry> Entries { get; private set; } = [];
    public void OnGet()
    {
        Entries = [
            new Entry(1, "2026-01-01", "Title 1", "Content 1", "Mood 1", Sentiment.positive, "Tag 1", null, 1),
            new Entry(2, "2026-01-02", "Title 2", "Content 2", "Mood 2", Sentiment.neutral, "Tag 2", null, 2),
            new Entry(3, "2026-01-03", "Title 3", "Content 3", "Mood 3", Sentiment.negative, "Tag 3", null, 3),
        ];
    }
}
