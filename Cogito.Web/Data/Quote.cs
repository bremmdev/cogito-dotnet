namespace Cogito.Web.Data;

public record Quote(
    int Id,
    string Content,
    string? Author);