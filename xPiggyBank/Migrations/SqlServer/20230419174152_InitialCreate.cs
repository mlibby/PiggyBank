//using Microsoft.EntityFrameworkCore.Migrations;

//#nullable disable

//namespace PiggyBank.Migrations
//{
//    /// <inheritdoc />
//    public partial class InitialCreate : Migration
//    {
//        /// <inheritdoc />
//        protected override void Up(MigrationBuilder migrationBuilder)
//        {
//            migrationBuilder.CreateTable(
//                name: "Commodities",
//                columns: table => new
//                {
//                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
//                    Name = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
//                    Symbol = table.Column<string>(type: "nvarchar(16)", maxLength: 16, nullable: true),
//                    Type = table.Column<string>(type: "nvarchar(max)", nullable: false),
//                    Cusip = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
//                    Precision = table.Column<int>(type: "int", nullable: false),
//                    Mnemonic = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false)
//                },
//                constraints: table =>
//                {
//                    table.PrimaryKey("PK_Commodities", x => x.Id)
//                        .Annotation("SqlServer:Clustered", false);
//                });

//            migrationBuilder.CreateTable(
//                name: "Configurations",
//                columns: table => new
//                {
//                    Id = table.Column<int>(type: "uniqueidentifier", nullable: false),
//                    Key = table.Column<string>(type: "varchar(255)", unicode: false, maxLength: 255, nullable: false),
//                    Value = table.Column<string>(type: "varchar(255)", unicode: false, maxLength: 255, nullable: false)
//                },
//                constraints: table =>
//                {
//                    table.PrimaryKey("PK_Configurations", x => x.Id)
//                        .Annotation("SqlServer:Clustered", false);
//                });

//            migrationBuilder.CreateTable(
//                name: "ExternalIds",
//                columns: table => new
//                {
//                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
//                    LocalId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
//                    ExternalId = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
//                    Type = table.Column<string>(type: "nvarchar(450)", nullable: false),
//                    Source = table.Column<string>(type: "nvarchar(450)", nullable: false)
//                },
//                constraints: table =>
//                {
//                    table.PrimaryKey("PK_ExternalIds", x => x.Id);
//                });

//            migrationBuilder.CreateTable(
//                name: "Accounts",
//                columns: table => new
//                {
//                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
//                    Name = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
//                    Description = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
//                    ParentId = table.Column<Guid>(type: "uniqueidentifier", nullable: true),
//                    Type = table.Column<string>(type: "nvarchar(max)", nullable: false),
//                    CommodityId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
//                    IsPlaceholder = table.Column<bool>(type: "bit", nullable: false)
//                },
//                constraints: table =>
//                {
//                    table.PrimaryKey("PK_Accounts", x => x.Id)
//                        .Annotation("SqlServer:Clustered", false);
//                    table.ForeignKey(
//                        name: "FK_Accounts_Accounts",
//                        column: x => x.ParentId,
//                        principalTable: "Accounts",
//                        principalColumn: "Id");
//                    table.ForeignKey(
//                        name: "FK_Accounts_Commodities",
//                        column: x => x.CommodityId,
//                        principalTable: "Commodities",
//                        principalColumn: "Id");
//                });

//            migrationBuilder.CreateTable(
//                name: "Transactions",
//                columns: table => new
//                {
//                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
//                    PostDate = table.Column<DateTime>(type: "datetime", nullable: false),
//                    EnterDate = table.Column<DateTime>(type: "datetime", nullable: false),
//                    Description = table.Column<string>(type: "nvarchar(2048)", maxLength: 2048, nullable: false),
//                    CommodityId = table.Column<Guid>(type: "uniqueidentifier", nullable: false)
//                },
//                constraints: table =>
//                {
//                    table.PrimaryKey("PK_Transactions", x => x.Id)
//                        .Annotation("SqlServer:Clustered", false);
//                    table.ForeignKey(
//                        name: "FK_Transactions_Commodities",
//                        column: x => x.CommodityId,
//                        principalTable: "Commodities",
//                        principalColumn: "Id");
//                });

//            migrationBuilder.CreateTable(
//                name: "Splits",
//                columns: table => new
//                {
//                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
//                    TransactionId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
//                    AccountId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
//                    Memo = table.Column<string>(type: "nvarchar(2048)", maxLength: 2048, nullable: false),
//                    Action = table.Column<string>(type: "nvarchar(2048)", maxLength: 2048, nullable: false),
//                    Value = table.Column<decimal>(type: "decimal(28,9)", nullable: false),
//                    Quantity = table.Column<decimal>(type: "decimal(28,9)", nullable: false)
//                },
//                constraints: table =>
//                {
//                    table.PrimaryKey("PK_Splits", x => x.Id)
//                        .Annotation("SqlServer:Clustered", false);
//                    table.ForeignKey(
//                        name: "FK_Splits_Accounts",
//                        column: x => x.AccountId,
//                        principalTable: "Accounts",
//                        principalColumn: "Id");
//                    table.ForeignKey(
//                        name: "FK_Splits_Transactions",
//                        column: x => x.TransactionId,
//                        principalTable: "Transactions",
//                        principalColumn: "Id");
//                });

//            migrationBuilder.CreateIndex(
//                name: "IX_Accounts_CommodityId",
//                table: "Accounts",
//                column: "CommodityId");

//            migrationBuilder.CreateIndex(
//                name: "IX_Accounts_ParentId",
//                table: "Accounts",
//                column: "ParentId");

//            migrationBuilder.CreateIndex(
//                name: "UX_LocalIDSourceType",
//                table: "ExternalIds",
//                columns: new[] { "LocalId", "Source", "Type" },
//                unique: true);

//            migrationBuilder.CreateIndex(
//                name: "IX_Splits_AccountId",
//                table: "Splits",
//                column: "AccountId");

//            migrationBuilder.CreateIndex(
//                name: "IX_Splits_TransactionId",
//                table: "Splits",
//                column: "TransactionId");

//            migrationBuilder.CreateIndex(
//                name: "IX_Transactions_CommodityId",
//                table: "Transactions",
//                column: "CommodityId");
//        }

//        /// <inheritdoc />
//        protected override void Down(MigrationBuilder migrationBuilder)
//        {
//            migrationBuilder.DropTable(
//                name: "Configurations");

//            migrationBuilder.DropTable(
//                name: "ExternalIds");

//            migrationBuilder.DropTable(
//                name: "Splits");

//            migrationBuilder.DropTable(
//                name: "Accounts");

//            migrationBuilder.DropTable(
//                name: "Transactions");

//            migrationBuilder.DropTable(
//                name: "Commodities");
//        }
//    }
//}
