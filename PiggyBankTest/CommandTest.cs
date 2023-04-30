namespace PiggyBankTest
{
    [TestClass]
    public class CommandTest
    {
        //[TestMethod]
        //public void TestConfigureNewKey()
        //{
        //    var data = new List<Configuration>().AsQueryable();
        //    var mockConfigurations = MockFactory.MockDbSet<Configuration>(data);

        //    var mockContext = new Mock<IPiggyBankContext>();
        //    mockContext.Setup(c => c.Configurations).Returns(mockConfigurations.Object);

        //    var command = new Command(mockContext.Object);
        //    command.Configure("test-key", "test-value");

        //    mockConfigurations.Verify(m => m.Add(It.Is<Configuration>(c => c.Key == "test-key" && c.Value == "test-value")), Times.Once);
        //    mockContext.Verify(m => m.SaveChanges(), Times.Once);
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