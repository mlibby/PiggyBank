using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace PiggyBank.Data.Migrations;

/// <inheritdoc />
public partial class Prices : Migration
{
    /// <inheritdoc />
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.CreateTable(
            name: "DataSource",
            columns: table => new
            {
                Id = table.Column<int>(type: "INTEGER", nullable: false),
                Text = table.Column<string>(type: "TEXT", maxLength: 2048, nullable: false)
            },
            constraints: table => table.PrimaryKey("PK_DataSource", x => x.Id));

        foreach (var e in Enum.GetNames(typeof(DataSource.DataSourceType)))
        {
            migrationBuilder.InsertData(
                table: "DataSource",
                columns: new[] { "Id", "Text" },
                columnTypes: new[] { "INTEGER", "TEXT" },
                values: new object[] { (int)Enum.Parse(typeof(DataSource.DataSourceType), e), e });
        }

        migrationBuilder.CreateTable(
            name: "Price_PriceSource",
            columns: table => new
            {
                Id = table.Column<int>(type: "INTEGER", nullable: false),
                Text = table.Column<string>(type: "TEXT", maxLength: 2048, nullable: false)
            },
            constraints: table => table.PrimaryKey("PK_Price_PriceSource", x => x.Id));

        foreach (var e in Enum.GetNames(typeof(Price.PriceSourceType)))
        {
            migrationBuilder.InsertData(
                table: "Price_PriceSource",
                columns: new[] { "Id", "Text" },
                columnTypes: new[] { "INTEGER", "TEXT" },
                values: new object[] { (int)Enum.Parse(typeof(Price.PriceSourceType), e), e });
        }

        migrationBuilder.CreateTable(
            name: "Price_PriceType",
            columns: table => new
            {
                Id = table.Column<int>(type: "INTEGER", nullable: false),
                Text = table.Column<string>(type: "TEXT", maxLength: 2048, nullable: false)
            },
            constraints: table => table.PrimaryKey("PK_Price_PriceType", x => x.Id));

        foreach (var e in Enum.GetNames(typeof(Price.PriceType)))
        {
            migrationBuilder.InsertData(
                table: "Price_PriceType",
                columns: new[] { "Id", "Text" },
                columnTypes: new[] { "INTEGER", "TEXT" },
                values: new object[] { (int)Enum.Parse(typeof(Price.PriceType), e), e });
        }

        migrationBuilder.CreateTable(
            name: "Prices",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "TEXT", nullable: false),
                CommodityId = table.Column<Guid>(type: "TEXT", nullable: false),
                Date = table.Column<DateOnly>(type: "date", nullable: false),
                PriceSource = table.Column<int>(type: "INTEGER", nullable: false),
                Type = table.Column<int>(type: "INTEGER", nullable: false),
                Value = table.Column<decimal>(type: "decimal(28, 9)", nullable: false),
                Source = table.Column<int>(type: "INTEGER", nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_Prices", x => x.Id);
                table.ForeignKey(
                    name: "FK_Prices_Commodities",
                    column: x => x.CommodityId,
                    principalTable: "Commodities",
                    principalColumn: "Id",
                    onDelete: ReferentialAction.Cascade);
                table.ForeignKey(
                    name: "FK_Prices_DataSource",
                    column: x => x.Source,
                    principalTable: "DataSource",
                    principalColumn: "Id",
                    onDelete: ReferentialAction.Cascade);
                table.ForeignKey(
                    name: "FK_Prices_PriceSource",
                    column: x => x.PriceSource,
                    principalTable: "Price_PriceSource",
                    principalColumn: "Id",
                    onDelete: ReferentialAction.Cascade);
                table.ForeignKey(
                    name: "FK_Prices_PriceType",
                    column: x => x.Type,
                    principalTable: "Price_PriceType",
                    principalColumn: "Id",
                    onDelete: ReferentialAction.Cascade);
            });

        migrationBuilder.CreateIndex(
            name: "IX_Prices_PriceSource",
            table: "Prices",
            column: "PriceSource");

        migrationBuilder.CreateIndex(
            name: "IX_Prices_PriceType",
            table: "Prices",
            column: "PriceType");

        migrationBuilder.CreateIndex(
            name: "IX_Prices_CommodityId",
            table: "Prices",
            column: "CommodityId");
    }

    /// <inheritdoc />
    protected override void Down(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.DropTable(name: "Prices");
        migrationBuilder.DropTable(name: "Price_PriceSource");
        migrationBuilder.DropTable(name: "Price_PriceType");
    }
}
