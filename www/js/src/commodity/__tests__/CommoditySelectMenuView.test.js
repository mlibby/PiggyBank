jest.mock("../../../lib/lit-html/lit-html.js", () => {
  return {
    html: jest.fn().mockImplementation(() => {
      return "htmlTemplate"
    }),
    render: jest.fn().mockImplementation(() => {
      return "renderedHtml"
    })
  }
})
jest.mock("../../PiggyBankUtil", () => {
  return {
    getUuid: jest.fn().mockReturnValue("TESTGUID")
  }
})

import { html, render } from "../../../lib/lit-html/lit-html.js"
import { CommoditySelectMenuView } from "../CommoditySelectMenuView"

test("CommoditySelectMenuView has render method", () => {
  const model = {
    get: jest.fn()
  }
  const collection = {
    models: [model]
  }
  const view = new CommoditySelectMenuView(collection)
  const renderedView = view.render()
  expect(view).toBe(renderedView)
  expect(html).toMatchSnapshot()
  expect(render).toHaveBeenCalledWith("htmlTemplate", view.el)
})