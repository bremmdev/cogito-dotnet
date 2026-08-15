using Microsoft.Data.Sqlite;

namespace Cogito.Web.Data;

public class EntryStore(IConfiguration configuration)
{
    private readonly string _connectionString =
        configuration.GetConnectionString("Cogito")
        ?? throw new InvalidOperationException("Connection string 'Cogito' is not configured.");

    public async Task<List<Entry>> GetRecentAsync(int limit)
    {
        using var connection = new SqliteConnection(_connectionString);
        await connection.OpenAsync();

        var command = connection.CreateCommand();
        command.CommandText =
            """
            SELECT e.id, e.date, e.title, e.content, m.name, m.sentiment
            FROM entry e
            LEFT JOIN mood m ON m.id = e.mood_id
            ORDER BY e.date DESC
            LIMIT $limit;
            """;
        command.Parameters.AddWithValue("$limit", limit);

        var entries = new List<Entry>();
        using var reader = await command.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            entries.Add(new Entry(
                Id: reader.GetInt32(0),
                Date: reader.GetString(1),
                Title: reader.GetString(2),
                Content: reader.GetString(3),
                Mood: reader.IsDBNull(4) ? null : reader.GetString(4),
                Sentiment: reader.IsDBNull(5)
                    ? null
                    : Enum.Parse<Sentiment>(reader.GetString(5), ignoreCase: true)));
        }
        return entries;
    }
}