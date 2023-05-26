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
            });

        migrationBuilder.CreateIndex(
            name: "IX_Prices_CommodityId",
            table: "Prices",
            column: "CommodityId");
    }

    /// <inheritdoc />
    protected override void Down(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.DropTable(
            name: "Prices");
    }
}
