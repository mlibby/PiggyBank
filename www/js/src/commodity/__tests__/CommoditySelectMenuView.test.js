import { mockTemplate } from "../../__tests__/TestHelpers"
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
  expect(render).toHaveBeenCalledWith(mockTemplate, view.el)
})