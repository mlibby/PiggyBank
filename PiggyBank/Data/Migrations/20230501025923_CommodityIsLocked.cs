using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace PiggyBank.Data.Migrations;

/// <inheritdoc />
public partial class CommodityIsLocked : Migration
{
    /// <inheritdoc />
    protected override void Up(MigrationBuilder migrationBuilder) => migrationBuilder.AddColumn<bool>(
            name: "IsLocked",
            table: "Commodities",
            type: "INTEGER",
            nullable: false,
            defaultValue: false);

    /// <inheritdoc />
    protected override void Down(MigrationBuilder migrationBuilder) => migrationBuilder.DropColumn(
            name: "IsLocked",
            table: "Commodities");
}
