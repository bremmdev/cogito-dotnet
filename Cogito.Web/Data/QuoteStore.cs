namespace Cogito.Web.Data;

public class QuoteStore(SqliteConnectionFactory connections)
{
    public async Task<List<Quote>> GetAllAsync()
    {
        await using var connection = await connections.OpenAsync();

        await using var command = connection.CreateCommand();
        command.CommandText =
            """
            SELECT id, content, author
            FROM quote
            ORDER BY author COLLATE NOCASE ASC;
            """;

        await using var reader = await command.ExecuteReaderAsync();
        var quotes = new List<Quote>();
        while (await reader.ReadAsync())
        {
            quotes.Add(new Quote(
                Id: reader.GetInt32(0),
                Content: reader.GetString(1),
                Author: reader.IsDBNull(2) ? null : reader.GetString(2)));
        }
        return quotes;
    }
}