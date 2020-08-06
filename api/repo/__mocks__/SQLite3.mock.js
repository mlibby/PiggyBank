exports.MockSQLite3 = class MockSQLite3 {
  constructor() {
    this.exec = jest.fn().mockReturnValue(this)
    this.function = jest.fn().mockReturnValue(this)
    this.pragma = jest.fn().mockReturnValue(this)
    this.all = jest.fn()
    this.get = jest.fn()
    this.pluck = jest.fn().mockReturnValue(this)
    this.prepare = jest.fn().mockReturnValue(this)
    this.run = jest.fn()
  }
}