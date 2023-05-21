using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace PiggyBank.Data.Migrations;

/// <inheritdoc />
public partial class Budgets : Migration
{
    /// <inheritdoc />
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.CreateTable(
            name: "Budgets",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "TEXT", nullable: false),
                Name = table.Column<string>(type: "TEXT", maxLength: 255, nullable: false),
                Description = table.Column<string>(type: "TEXT", maxLength: 255, nullable: false),
                StartDate = table.Column<DateOnly>(type: "date", nullable: false),
                EndDate = table.Column<DateOnly>(type: "date", nullable: false),
                IsHidden = table.Column<bool>(type: "INTEGER", nullable: false)
            },
            constraints: table => table.PrimaryKey("PK_Budgets", x => x.Id));

        migrationBuilder.CreateTable(
            name: "BudgetAmounts",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "TEXT", nullable: false),
                BudgetId = table.Column<Guid>(type: "TEXT", nullable: false),
                AccountId = table.Column<Guid>(type: "TEXT", nullable: false),
                Type = table.Column<string>(type: "TEXT", nullable: false),
                AmountDate = table.Column<DateOnly>(type: "date", nullable: false),
                Value = table.Column<decimal>(type: "TEXT", nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_BudgetAmounts", x => x.Id);
                table.ForeignKey(
                    name: "FK_BudgetAmount_Account",
                    column: x => x.AccountId,
                    principalTable: "Accounts",
                    principalColumn: "Id",
                    onDelete: ReferentialAction.Cascade);
                table.ForeignKey(
                    name: "FK_BudgetAmount_Budget",
                    column: x => x.BudgetId,
                    principalTable: "Budgets",
                    principalColumn: "Id");
            });

        migrationBuilder.CreateIndex(
            name: "IX_BudgetAmounts_AccountId",
            table: "BudgetAmounts",
            column: "AccountId");

        migrationBuilder.CreateIndex(
            name: "IX_BudgetAmounts_BudgetId",
            table: "BudgetAmounts",
            column: "BudgetId");
    }

    /// <inheritdoc />
    protected override void Down(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.DropTable(
            name: "BudgetAmounts");

        migrationBuilder.DropTable(
            name: "Budgets");
    }
}
