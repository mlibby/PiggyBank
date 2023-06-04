using Microsoft.EntityFrameworkCore.Migrations;

namespace PiggyBank.Helpers;

public static class MigrationHelper
{
    public static void CreateEnumTable<TenumType>(string name, MigrationBuilder migrationBuilder)
    {
        migrationBuilder.CreateTable(
            name: name,
            columns: table => new
            {
                Value = table.Column<int>(type: "INTEGER", nullable: false),
                Name = table.Column<string>(type: "TEXT", maxLength: 255, nullable: false)
            },
            constraints: table => table.PrimaryKey($"PK_{name}", x => x.Value));

        foreach (var e in Enum.GetNames(typeof(TenumType)))
        {
            migrationBuilder.InsertData(
                table: name,
                columns: new[] { "Value", "Name" },
                columnTypes: new[] { "INTEGER", "TEXT" },
                values: new object[] { (int)Enum.Parse(typeof(TenumType), e), e }
                );
        }

        migrationBuilder.CreateIndex(
            name: $"IX_{name}_Value",
            table: name,
            column: "Value");
    }
}

