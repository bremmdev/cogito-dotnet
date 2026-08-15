using Microsoft.AspNetCore.Mvc.RazorPages;
using Cogito.Web.Data;

namespace Cogito.Web.Pages;

public class EntriesModel(EntryStore entries) : PageModel
{
    public IReadOnlyList<Entry> Entries { get; private set; } = [];

    public async Task OnGetAsync()
    {
        Entries = await entries.GetRecentAsync(12);
    }
}
