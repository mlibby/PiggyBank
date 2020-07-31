test("PiggyBankApp", () => {
  const $mock = {
    ready: jest.fn()
  }
  global.$ = jest.fn().mockReturnValue($mock)
  const app = require("../PiggyBankApp")
})