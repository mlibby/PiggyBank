using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace PiggyBank.Data.Migrations;

/// <inheritdoc />
public partial class AddSourceToImportables : Migration
{
    /// <inheritdoc />
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.AddColumn<string>(
            name: "Source",
            table: "Transactions",
            type: "TEXT",
            nullable: false,
            defaultValue: "");

        migrationBuilder.AddColumn<string>(
            name: "Source",
            table: "Splits",
            type: "TEXT",
            nullable: false,
            defaultValue: "");

        migrationBuilder.AddColumn<string>(
            name: "Source",
            table: "Commodities",
            type: "TEXT",
            nullable: false,
            defaultValue: "");

        migrationBuilder.AddColumn<string>(
            name: "Source",
            table: "Accounts",
            type: "TEXT",
            nullable: false,
            defaultValue: "");
    }

    /// <inheritdoc />
    protected override void Down(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.DropColumn(
            name: "Source",
            table: "Transactions");

        migrationBuilder.DropColumn(
            name: "Source",
            table: "Splits");

        migrationBuilder.DropColumn(
            name: "Source",
            table: "Commodities");

        migrationBuilder.DropColumn(
            name: "Source",
            table: "Accounts");
    }
}
