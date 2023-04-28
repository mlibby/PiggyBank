//using Microsoft.EntityFrameworkCore.Migrations;

//#nullable disable

//namespace PiggyBank.Migrations
//{
//    /// <inheritdoc />
//    public partial class AccountFlags : Migration
//    {
//        /// <inheritdoc />
//        protected override void Up(MigrationBuilder migrationBuilder)
//        {
//            migrationBuilder.DropPrimaryKey(
//                name: "PK_Configurations",
//                table: "Configurations");

//            migrationBuilder.AddColumn<bool>(
//                name: "IsHidden",
//                table: "Accounts",
//                type: "bit",
//                nullable: false,
//                defaultValue: false);

//            migrationBuilder.AddColumn<bool>(
//                name: "IsLocked",
//                table: "Accounts",
//                type: "bit",
//                nullable: false,
//                defaultValue: false);

//            migrationBuilder.AddPrimaryKey(
//                name: "PK_Configurations",
//                table: "Configurations",
//                column: "Id")
//                .Annotation("SqlServer:Clustered", false);
//        }

//        /// <inheritdoc />
//        protected override void Down(MigrationBuilder migrationBuilder)
//        {
//            migrationBuilder.DropPrimaryKey(
//                name: "PK_Configurations",
//                table: "Configurations");

//            migrationBuilder.DropColumn(
//                name: "IsHidden",
//                table: "Accounts");

//            migrationBuilder.DropColumn(
//                name: "IsLocked",
//                table: "Accounts");

//            migrationBuilder.AddPrimaryKey(
//                name: "PK_Configurations",
//                table: "Configurations",
//                column: "Id");
//        }
//    }
//}
