using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace PiggyBank.Migrations;

/// <inheritdoc />
public partial class InitialCreate : Migration
{
    /// <inheritdoc />
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        MigrationHelper.CreateEnumTable<AccountType>("AccountType", migrationBuilder);
        MigrationHelper.CreateEnumTable<AmountType>("AmountType", migrationBuilder);
        MigrationHelper.CreateEnumTable<CommodityType>("CommodityType", migrationBuilder);
        MigrationHelper.CreateEnumTable<DataSource>("DataSource", migrationBuilder);
        MigrationHelper.CreateEnumTable<PriceSource>("PriceSource", migrationBuilder);
        MigrationHelper.CreateEnumTable<PriceType>("PriceType", migrationBuilder);
        MigrationHelper.CreateEnumTable<SettingType>("SettingType", migrationBuilder);

        migrationBuilder.CreateTable(
            name: "AspNetRoles",
            columns: table => new
            {
                Id = table.Column<string>(type: "TEXT", nullable: false),
                Name = table.Column<string>(type: "TEXT", maxLength: 256, nullable: true),
                NormalizedName = table.Column<string>(type: "TEXT", maxLength: 256, nullable: true),
                ConcurrencyStamp = table.Column<string>(type: "TEXT", nullable: true)
            },
            constraints: table => table.PrimaryKey("PK_AspNetRoles", x => x.Id));

        migrationBuilder.CreateTable(
            name: "AspNetUsers",
            columns: table => new
            {
                Id = table.Column<string>(type: "TEXT", nullable: false),
                UserName = table.Column<string>(type: "TEXT", maxLength: 256, nullable: true),
                NormalizedUserName = table.Column<string>(type: "TEXT", maxLength: 256, nullable: true),
                Email = table.Column<string>(type: "TEXT", maxLength: 256, nullable: true),
                NormalizedEmail = table.Column<string>(type: "TEXT", maxLength: 256, nullable: true),
                EmailConfirmed = table.Column<bool>(type: "INTEGER", nullable: false),
                PasswordHash = table.Column<string>(type: "TEXT", nullable: true),
                SecurityStamp = table.Column<string>(type: "TEXT", nullable: true),
                ConcurrencyStamp = table.Column<string>(type: "TEXT", nullable: true),
                PhoneNumber = table.Column<string>(type: "TEXT", nullable: true),
                PhoneNumberConfirmed = table.Column<bool>(type: "INTEGER", nullable: false),
                TwoFactorEnabled = table.Column<bool>(type: "INTEGER", nullable: false),
                LockoutEnd = table.Column<DateTimeOffset>(type: "TEXT", nullable: true),
                LockoutEnabled = table.Column<bool>(type: "INTEGER", nullable: false),
                AccessFailedCount = table.Column<int>(type: "INTEGER", nullable: false)
            },
            constraints: table => table.PrimaryKey("PK_AspNetUsers", x => x.Id));

        migrationBuilder.CreateTable(
            name: "Budgets",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "TEXT", nullable: false),
                Name = table.Column<string>(type: "TEXT", maxLength: 255, nullable: false),
                Description = table.Column<string>(type: "TEXT", maxLength: 255, nullable: true),
                StartDate = table.Column<DateOnly>(type: "date", nullable: false),
                EndDate = table.Column<DateOnly>(type: "date", nullable: false),
                IsHidden = table.Column<bool>(type: "INTEGER", nullable: false)
            },
            constraints: table => table.PrimaryKey("PK_Budgets", x => x.Id));

        migrationBuilder.CreateTable(
            name: "Commodities",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "TEXT", nullable: false),
                Name = table.Column<string>(type: "TEXT", maxLength: 255, nullable: false),
                Symbol = table.Column<string>(type: "TEXT", maxLength: 1, nullable: true),
                CommodityType = table.Column<int>(type: "INTEGER", nullable: false),
                Cusip = table.Column<string>(type: "TEXT", maxLength: 255, nullable: false),
                Precision = table.Column<int>(type: "INTEGER", nullable: false),
                Mnemonic = table.Column<string>(type: "TEXT", maxLength: 255, nullable: false),
                IsLocked = table.Column<bool>(type: "INTEGER", nullable: false),
                DataSource = table.Column<int>(type: "INTEGER", nullable: false),
                Updated = table.Column<DateTime>(type: "datetime", nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_Commodities", x => x.Id);
                table.ForeignKey(
                    name: "FK_Commodities_CommodityType",
                    column: x => x.CommodityType,
                    principalTable: "CommodityType",
                    principalColumn: "Value");
                table.ForeignKey(
                    name: "FK_Commodities_DataSource",
                    column: x => x.DataSource,
                    principalTable: "DataSource",
                    principalColumn: "Value");
            });

        migrationBuilder.CreateTable(
            name: "Settings",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "TEXT", nullable: false),
                SettingType = table.Column<int>(type: "INTEGER", nullable: false),
                Value = table.Column<string>(type: "TEXT", maxLength: 4096, nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_Settings", x => x.Id);
                table.ForeignKey(
                    name: "FK_Settings_SettingType",
                    column: x => x.SettingType,
                    principalTable: "SettingType",
                    principalColumn: "Value");
            });

        migrationBuilder.CreateTable(
            name: "AspNetRoleClaims",
            columns: table => new
            {
                Id = table.Column<int>(type: "INTEGER", nullable: false)
                    .Annotation("Sqlite:Autoincrement", true),
                RoleId = table.Column<string>(type: "TEXT", nullable: false),
                ClaimType = table.Column<string>(type: "TEXT", nullable: true),
                ClaimValue = table.Column<string>(type: "TEXT", nullable: true)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_AspNetRoleClaims", x => x.Id);
                table.ForeignKey(
                    name: "FK_AspNetRoleClaims_AspNetRoles_RoleId",
                    column: x => x.RoleId,
                    principalTable: "AspNetRoles",
                    principalColumn: "Id",
                    onDelete: ReferentialAction.Cascade);
            });

        migrationBuilder.CreateTable(
            name: "AspNetUserClaims",
            columns: table => new
            {
                Id = table.Column<int>(type: "INTEGER", nullable: false)
                    .Annotation("Sqlite:Autoincrement", true),
                UserId = table.Column<string>(type: "TEXT", nullable: false),
                ClaimType = table.Column<string>(type: "TEXT", nullable: true),
                ClaimValue = table.Column<string>(type: "TEXT", nullable: true)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_AspNetUserClaims", x => x.Id);
                table.ForeignKey(
                    name: "FK_AspNetUserClaims_AspNetUsers_UserId",
                    column: x => x.UserId,
                    principalTable: "AspNetUsers",
                    principalColumn: "Id",
                    onDelete: ReferentialAction.Cascade);
            });

        migrationBuilder.CreateTable(
            name: "AspNetUserLogins",
            columns: table => new
            {
                LoginProvider = table.Column<string>(type: "TEXT", nullable: false),
                ProviderKey = table.Column<string>(type: "TEXT", nullable: false),
                ProviderDisplayName = table.Column<string>(type: "TEXT", nullable: true),
                UserId = table.Column<string>(type: "TEXT", nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_AspNetUserLogins", x => new { x.LoginProvider, x.ProviderKey });
                table.ForeignKey(
                    name: "FK_AspNetUserLogins_AspNetUsers_UserId",
                    column: x => x.UserId,
                    principalTable: "AspNetUsers",
                    principalColumn: "Id",
                    onDelete: ReferentialAction.Cascade);
            });

        migrationBuilder.CreateTable(
            name: "AspNetUserRoles",
            columns: table => new
            {
                UserId = table.Column<string>(type: "TEXT", nullable: false),
                RoleId = table.Column<string>(type: "TEXT", nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_AspNetUserRoles", x => new { x.UserId, x.RoleId });
                table.ForeignKey(
                    name: "FK_AspNetUserRoles_AspNetRoles_RoleId",
                    column: x => x.RoleId,
                    principalTable: "AspNetRoles",
                    principalColumn: "Id",
                    onDelete: ReferentialAction.Cascade);
                table.ForeignKey(
                    name: "FK_AspNetUserRoles_AspNetUsers_UserId",
                    column: x => x.UserId,
                    principalTable: "AspNetUsers",
                    principalColumn: "Id",
                    onDelete: ReferentialAction.Cascade);
            });

        migrationBuilder.CreateTable(
            name: "AspNetUserTokens",
            columns: table => new
            {
                UserId = table.Column<string>(type: "TEXT", nullable: false),
                LoginProvider = table.Column<string>(type: "TEXT", nullable: false),
                Name = table.Column<string>(type: "TEXT", nullable: false),
                Value = table.Column<string>(type: "TEXT", nullable: true)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_AspNetUserTokens", x => new { x.UserId, x.LoginProvider, x.Name });
                table.ForeignKey(
                    name: "FK_AspNetUserTokens_AspNetUsers_UserId",
                    column: x => x.UserId,
                    principalTable: "AspNetUsers",
                    principalColumn: "Id",
                    onDelete: ReferentialAction.Cascade);
            });

        migrationBuilder.CreateTable(
            name: "Accounts",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "TEXT", nullable: false),
                Name = table.Column<string>(type: "TEXT", maxLength: 255, nullable: false),
                Description = table.Column<string>(type: "TEXT", maxLength: 255, nullable: false),
                ParentId = table.Column<Guid>(type: "TEXT", nullable: true),
                AccountType = table.Column<int>(type: "INTEGER", nullable: false),
                CommodityId = table.Column<Guid>(type: "TEXT", nullable: false),
                IsHidden = table.Column<bool>(type: "INTEGER", nullable: false),
                IsLocked = table.Column<bool>(type: "INTEGER", nullable: false),
                IsPlaceholder = table.Column<bool>(type: "INTEGER", nullable: false),
                DataSource = table.Column<int>(type: "INTEGER", nullable: false),
                Updated = table.Column<DateTime>(type: "datetime", nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_Accounts", x => x.Id);
                table.ForeignKey(
                    name: "FK_Accounts_Accounts",
                    column: x => x.ParentId,
                    principalTable: "Accounts",
                    principalColumn: "Id");
                table.ForeignKey(
                    name: "FK_Accounts_Commodities",
                    column: x => x.CommodityId,
                    principalTable: "Commodities",
                    principalColumn: "Id");
                table.ForeignKey(
                    name: "FK_Accounts_AccountType",
                    column: x => x.AccountType,
                    principalTable: "AccountType",
                    principalColumn: "Value");
                table.ForeignKey(
                    name: "FK_Accounts_DataSource",
                    column: x => x.DataSource,
                    principalTable: "DataSource",
                    principalColumn: "Value");
            });

        migrationBuilder.CreateTable(
            name: "Prices",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "TEXT", nullable: false),
                CommodityId = table.Column<Guid>(type: "TEXT", nullable: false),
                Date = table.Column<DateOnly>(type: "date", nullable: false),
                PriceSource = table.Column<int>(type: "INTEGER", nullable: false),
                PriceType = table.Column<int>(type: "INTEGER", nullable: false),
                Value = table.Column<decimal>(type: "decimal(28, 9)", nullable: false),
                DataSource = table.Column<int>(type: "INTEGER", nullable: false),
                Updated = table.Column<DateTime>(type: "TEXT", nullable: false)
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
                    name: "FK_Prices_PriceSource",
                    column: x => x.PriceSource,
                    principalTable: "PriceSource",
                    principalColumn: "Value");
                table.ForeignKey(
                    name: "FK_Prices_PriceType",
                    column: x => x.PriceType,
                    principalTable: "PriceType",
                    principalColumn: "Value");
                table.ForeignKey(
                    name: "FK_Prices_DataSource",
                    column: x => x.DataSource,
                    principalTable: "DataSource",
                    principalColumn: "Value");
            });

        migrationBuilder.CreateTable(
            name: "Transactions",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "TEXT", nullable: false),
                PostDate = table.Column<DateOnly>(type: "date", nullable: false),
                Description = table.Column<string>(type: "TEXT", maxLength: 2048, nullable: false),
                DataSource = table.Column<int>(type: "INTEGER", nullable: false),
                Updated = table.Column<DateTime>(type: "datetime", nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_Transactions", x => x.Id);
                table.ForeignKey(
                    name: "FK_Transactions_DataSource",
                    column: x => x.DataSource,
                    principalTable: "DataSource",
                    principalColumn: "Value");
            });

        migrationBuilder.CreateTable(
            name: "BudgetAmounts",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "TEXT", nullable: false),
                BudgetId = table.Column<Guid>(type: "TEXT", nullable: false),
                AccountId = table.Column<Guid>(type: "TEXT", nullable: false),
                AmountType = table.Column<int>(type: "INTEGER", nullable: false),
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
                table.ForeignKey(
                    name: "FK_BudgetAmounts_AmountType",
                    column: x => x.AmountType,
                    principalTable: "AmountType",
                    principalColumn: "Value");
            });

        migrationBuilder.CreateTable(
            name: "Splits",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "TEXT", nullable: false),
                TransactionId = table.Column<Guid>(type: "TEXT", nullable: false),
                AccountId = table.Column<Guid>(type: "TEXT", nullable: false),
                Memo = table.Column<string>(type: "TEXT", maxLength: 2048, nullable: false),
                Action = table.Column<string>(type: "TEXT", maxLength: 2048, nullable: false),
                Value = table.Column<decimal>(type: "decimal(28, 9)", nullable: false),
                Quantity = table.Column<decimal>(type: "decimal(28, 9)", nullable: false),
                DataSource = table.Column<int>(type: "INTEGER", nullable: false),
                Updated = table.Column<DateTime>(type: "datetime", nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_Splits", x => x.Id);
                table.ForeignKey(
                    name: "FK_Splits_Accounts",
                    column: x => x.AccountId,
                    principalTable: "Accounts",
                    principalColumn: "Id");
                table.ForeignKey(
                    name: "FK_Splits_Transactions",
                    column: x => x.TransactionId,
                    principalTable: "Transactions",
                    principalColumn: "Id");
                table.ForeignKey(
                    name: "FK_Splits_DataSource",
                    column: x => x.DataSource,
                    principalTable: "DataSource",
                    principalColumn: "Value");
            });

        migrationBuilder.CreateIndex(
            name: "IX_Accounts_CommodityId",
            table: "Accounts",
            column: "CommodityId");

        migrationBuilder.CreateIndex(
            name: "IX_Accounts_ParentId",
            table: "Accounts",
            column: "ParentId");

        migrationBuilder.CreateIndex(
            name: "IX_AspNetRoleClaims_RoleId",
            table: "AspNetRoleClaims",
            column: "RoleId");

        migrationBuilder.CreateIndex(
            name: "RoleNameIndex",
            table: "AspNetRoles",
            column: "NormalizedName",
            unique: true);

        migrationBuilder.CreateIndex(
            name: "IX_AspNetUserClaims_UserId",
            table: "AspNetUserClaims",
            column: "UserId");

        migrationBuilder.CreateIndex(
            name: "IX_AspNetUserLogins_UserId",
            table: "AspNetUserLogins",
            column: "UserId");

        migrationBuilder.CreateIndex(
            name: "IX_AspNetUserRoles_RoleId",
            table: "AspNetUserRoles",
            column: "RoleId");

        migrationBuilder.CreateIndex(
            name: "EmailIndex",
            table: "AspNetUsers",
            column: "NormalizedEmail");

        migrationBuilder.CreateIndex(
            name: "UserNameIndex",
            table: "AspNetUsers",
            column: "NormalizedUserName",
            unique: true);

        migrationBuilder.CreateIndex(
            name: "IX_BudgetAmounts_AccountId",
            table: "BudgetAmounts",
            column: "AccountId");

        migrationBuilder.CreateIndex(
            name: "IX_BudgetAmounts_BudgetId",
            table: "BudgetAmounts",
            column: "BudgetId");

        migrationBuilder.CreateIndex(
            name: "IX_Prices_CommodityId",
            table: "Prices",
            column: "CommodityId");

        migrationBuilder.CreateIndex(
            name: "IX_Splits_AccountId",
            table: "Splits",
            column: "AccountId");

        migrationBuilder.CreateIndex(
            name: "IX_Splits_TransactionId",
            table: "Splits",
            column: "TransactionId");

        migrationBuilder.CreateIndex(
            name: "IX_Transactions_CommodityId",
            table: "Transactions",
            column: "CommodityId");
    }
}
