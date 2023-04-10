using PiggyBank;

namespace PiggyBankTest
{
    [TestClass]
    public class CommandTest
    {
        [TestMethod]
        public void TestConfigureNewKey()
        {
            var data = new List<Configuration>().AsQueryable();

            var mockContext = new Mock<IPiggyBankContext>();
            var mockConfigurations = MockDbSet<Configuration>(data);
            mockContext.Setup(c => c.Configurations).Returns(mockConfigurations.Object);

            var command = new Command(mockContext.Object);
            command.Configure("test-key", "test-value");

            mockConfigurations.Verify(m => m.Add(It.Is<Configuration>(c => c.Key == "test-key" && c.Value == "test-value")), Times.Once);
            mockContext.Verify(m => m.SaveChanges(), Times.Once);
        }

        private static Mock<DbSet<T>> MockDbSet<T>(IQueryable data) where T : class
        {
            var mock = new Mock<DbSet<T>>();
            mock.As<IQueryable<T>>().Setup(m => m.Provider).Returns(data.Provider);
            mock.As<IQueryable<T>>().Setup(m => m.Expression).Returns(data.Expression);
            mock.As<IQueryable<T>>().Setup(m => m.ElementType).Returns(data.ElementType);
            mock.As<IQueryable<T>>().Setup(m => m.GetEnumerator()).Returns((IEnumerator<T>)data.GetEnumerator());
            return mock;
        }
    }
}