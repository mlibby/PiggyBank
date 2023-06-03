//using Microsoft.EntityFrameworkCore.Migrations;

//#nullable disable

//namespace PiggyBank.Data.Migrations
//{
//    /// <inheritdoc />
//    public partial class Configurations : Migration
//    {
//        /// <inheritdoc />
//        protected override void Up(MigrationBuilder migrationBuilder)
//        {
//            migrationBuilder.CreateTable(
//                name: "ConfigurationKeys",
//                columns: table => new
//                {
//                    Id = table.Column<int>(type: "INTEGER", nullable: false),
//                    Text = table.Column<string>(type: "TEXT", maxLength: 2048, nullable: false)
//                },
//                constraints: table =>
//                {
//                    table.PrimaryKey("PK_ConfigurationKey", x => x.Id);
//                });

//            foreach (var e in Enum.GetNames(typeof(Configuration.ConfigurationKey)))
//            {
//                migrationBuilder.InsertData(
//                    table: "ConfigurationKeys",
//                    columns: new[] { "Id", "Text" },
//                    columnTypes: new[] { "INTEGER", "TEXT" },
//                    values: new object[] { (int)Enum.Parse(typeof(Configuration.ConfigurationKey), e), e });
//            }

//            migrationBuilder.DropTable("Configurations");

//            migrationBuilder.CreateTable(
//                name: "Configurations",
//                columns: table => new
//                {
//                    Id = table.Column<Guid>(type: "TEXT", nullable: false),
//                    Key = table.Column<int>(type: "INTEGER", nullable: false),
//                    Value = table.Column<string>(type: "TEXT", unicode: false, maxLength: 255, nullable: false)
//                },
//                constraints: table =>
//                {
//                    table.PrimaryKey("PK_Configurations", x => x.Id);
//                    table.ForeignKey(
//                        name: "FK_Configurations_ConfigurationKeys",
//                        column: x => x.Key,
//                        principalTable: "ConfigurationKeys",
//                        principalColumn: "Id");
//                });

//        }

//        /// <inheritdoc />
//        protected override void Down(MigrationBuilder migrationBuilder)
//        {

//        }
//    }
//}
