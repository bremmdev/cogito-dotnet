using Cogito.Web.Data;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddRazorPages();

// Add services for the database
builder.Services.AddSingleton<SqliteConnectionFactory>();
builder.Services.AddScoped<EntryStore>();
builder.Services.AddScoped<QuoteStore>();

var app = builder.Build();

// Resolve eagerly so a missing connection string fails at startup, not on first request.
app.Services.GetRequiredService<SqliteConnectionFactory>();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();

app.UseRouting();

app.UseAuthorization();

app.MapStaticAssets();
app.MapRazorPages()
   .WithStaticAssets();

app.Run();
