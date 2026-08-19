using Microsoft.Data.Sqlite;

namespace Cogito.Web.Data;

public class QuoteStore(IConfiguration configuration)
{
    private readonly string _connectionString =
        configuration.GetConnectionString("Cogito")
        ?? throw new InvalidOperationException("Connection string 'Cogito' is not configured.");

    public async Task<List<Quote>> GetAllAsync()
    {
        using var connection = new SqliteConnection(_connectionString);
        await connection.OpenAsync();

        var command = connection.CreateCommand();
        command.CommandText =
            """
            SELECT id, content, author
            FROM quote
            ORDER BY author COLLATE NOCASE ASC;
            """;

        using var reader = await command.ExecuteReaderAsync();
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