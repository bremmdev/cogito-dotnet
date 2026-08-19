using Microsoft.Data.Sqlite;

namespace Cogito.Web.Data;

public class SqliteConnectionFactory(IConfiguration configuration)
{
    private readonly string _connectionString =
        configuration.GetConnectionString("Cogito")
        ?? throw new InvalidOperationException("Connection string 'Cogito' is not configured.");

    public async Task<SqliteConnection> OpenAsync()
    {
        var connection = new SqliteConnection(_connectionString);
        await connection.OpenAsync();
        return connection;
    }
}
