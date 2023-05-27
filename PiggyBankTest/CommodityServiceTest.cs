namespace PiggyBankTest
{
    [TestClass]
    public class CommodityServiceTest
    {
        //[TestMethod]
        //public async Task TestFoo()
        //{
        //    var data = new List<Commodity>().AsQueryable();
        //    var mockCommodities = MockFactory.MockDbSet<Commodity>(data);
        //    var mockContext = MockFactory.MockPiggyBankContext(mockCommodities);

        //    var commodityService = new CommodityService(mockContext.Object);

        //    var result = await commodityService.GetCommoditiesAsync();
        //    Assert.IsNotNull(result);
        //    Assert.AreEqual(result.Count(), 0);
        //}

        //[TestMethod]
        //public void TestConfigureModifyKey()
        //{
        //    var configuration = new Configuration
        //    {
        //        Key = "test-key",
        //        Value = "test-value"
        //    };

        //    var data = new List<Configuration>() { configuration }.AsQueryable();
        //    var mockConfigurations = MockFactory.MockDbSet<Configuration>(data);

        //    var mockContext = new Mock<IPiggyBankContext>();
        //    mockContext.Setup(c => c.Configurations).Returns(mockConfigurations.Object);

        //    var command = new Command(mockContext.Object);
        //    command.Configure("test-key", "new-value");

        //    Assert.AreEqual("new-value", configuration.Value);
        //    mockContext.Verify(m => m.SaveChanges(), Times.Once);
        //}
    }
}