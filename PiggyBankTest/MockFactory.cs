namespace PiggyBankTest
{
    internal static class MockFactory
    {
        public static Mock<IPiggyBankContext> MockPiggyBankContext(Mock<DbSet<Configuration>>? mockConfigurations = null)
        {
            var mockContext = new Mock<IPiggyBankContext>();

            if (mockConfigurations is object)
            {
                mockContext.Setup(c => c.Configurations).Returns(mockConfigurations.Object);
            }

            return mockContext;
        }

        public static Mock<DbSet<T>> MockDbSet<T>(IQueryable data) where T : class
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
