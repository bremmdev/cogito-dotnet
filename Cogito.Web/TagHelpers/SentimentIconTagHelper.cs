using Cogito.Web.Data;
using Microsoft.AspNetCore.Razor.TagHelpers;

namespace Cogito.Web.TagHelpers;

/// <summary>
/// Renders the mood icon belonging to an entry's sentiment:
/// <c>&lt;sentiment-icon sentiment="@entry.Sentiment" /&gt;</c>.
/// Falls back to a muted placeholder when the entry has no sentiment.
/// </summary>
[HtmlTargetElement("sentiment-icon", TagStructure = TagStructure.WithoutEndTag)]
public class SentimentIconTagHelper : TagHelper
{
    /// <summary>The entry's sentiment. Bound from the <c>sentiment</c> attribute.</summary>
    public Sentiment? Sentiment { get; set; }

    /// <summary>Width and height in pixels. Bound from the <c>size</c> attribute.</summary>
    public int Size { get; set; } = 24;

    public override void Process(TagHelperContext context, TagHelperOutput output)
    {
        // The enum members need the Data. prefix here: inside this class the name
        // "Sentiment" already refers to the property above, which hides the type.
        // The discard arm covers both null and any value not in the enum.
        var (cssClass, paths) = Sentiment switch
        {
            Data.Sentiment.Positive => ("positive-sentiment", Smile),
            Data.Sentiment.Neutral => ("neutral-sentiment", Meh),
            Data.Sentiment.Negative => ("negative-sentiment", Frown),
            _ => ("unknown-sentiment", Unknown)
        };

        output.TagName = "svg";
        // Without this the browser gets <svg /> and swallows the rest of the page.
        output.TagMode = TagMode.StartTagAndEndTag;

        output.Attributes.SetAttribute("xmlns", "http://www.w3.org/2000/svg");
        output.Attributes.SetAttribute("viewBox", "0 0 24 24");
        output.Attributes.SetAttribute("width", Size);
        output.Attributes.SetAttribute("height", Size);
        output.Attributes.SetAttribute("fill", "none");
        output.Attributes.SetAttribute("stroke-width", "2");
        output.Attributes.SetAttribute("stroke-linecap", "round");
        output.Attributes.SetAttribute("stroke-linejoin", "round");
        // No stroke attribute: the colour comes from the class in style.css.
        output.Attributes.SetAttribute("class", cssClass);

        output.Content.SetHtmlContent(paths);
    }

    private const string Smile =
        """
        <circle cx="12" cy="12" r="10" />
        <path d="M8 14s1.5 2 4 2 4-2 4-2" />
        <line x1="9" x2="9.01" y1="9" y2="9" />
        <line x1="15" x2="15.01" y1="9" y2="9" />
        """;

    private const string Meh =
        """
        <circle cx="12" cy="12" r="10" />
        <line x1="8" x2="16" y1="15" y2="15" />
        <line x1="9" x2="9.01" y1="9" y2="9" />
        <line x1="15" x2="15.01" y1="9" y2="9" />
        """;

    private const string Frown =
        """
        <circle cx="12" cy="12" r="10" />
        <path d="M16 16s-1.5-2-4-2-4 2-4 2" />
        <line x1="9" x2="9.01" y1="9" y2="9" />
        <line x1="15" x2="15.01" y1="9" y2="9" />
        """;

    private const string Unknown =
        """
        <circle cx="12" cy="12" r="10" />
        <path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3" />
        <line x1="12" x2="12.01" y1="17" y2="17" />
        """;
}
