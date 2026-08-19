using Microsoft.AspNetCore.Mvc.RazorPages;
using Cogito.Web.Data;

namespace Cogito.Web.Pages;

public class QuotesModel(QuoteStore quotes) : PageModel
{
    public IReadOnlyList<Quote> Quotes { get; private set; } = [];

    public async Task OnGetAsync()
    {
        Quotes = await quotes.GetAllAsync();
    }
}
