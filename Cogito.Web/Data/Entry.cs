namespace Cogito.Web.Data;

public enum Sentiment
{
    Positive,
    Neutral,
    Negative
}

public record Entry(
    int Id,
    string Date,
    string Title,
    string Content,
    string? Mood,
    Sentiment? Sentiment);