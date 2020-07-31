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

import { html, render } from "../../../lib/lit-html/lit-html.js"
import { CommodityFormView } from "../CommodityFormView"

test("CommodityFormView has render method", () => {
  const model = {
    attributes: [],
    get: jest.fn()
  }
  const view = new CommodityFormView({ model })
  const renderedView = view.render()
  expect(view).toBe(renderedView)
  expect(html).toMatchSnapshot()
  expect(render).toHaveBeenCalledWith("htmlTemplate", view.el)
})