"use strict"

const jestConfig = require("../jest.config")

const litHtml = {
  render: jest.fn(),
  html: jest.fn()
}

module.exports = litHtml