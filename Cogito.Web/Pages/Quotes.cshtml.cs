using Microsoft.AspNetCore.Mvc.RazorPages;

namespace Cogito.Web.Pages;

public record Quote(int Id, string Content, string? Author);

public class QuotesModel : PageModel
{
    public IReadOnlyList<Quote> Quotes { get; private set; } = [];

    public void OnGet()
    {
        Quotes =
        [
            new Quote(1, "The unexamined life is not worth living.", "Socrates"),
            new Quote(2, "We suffer more often in imagination than in reality.", "Seneca"),
            new Quote(3, "The obstacle is the way.", null),
        ];
    }
}
