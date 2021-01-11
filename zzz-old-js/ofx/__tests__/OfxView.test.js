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
import { OfxView } from "../OfxView"

test("OfxView has render method", () => {
  const model = {
    attributes: jest.fn()
  }
  const view = new OfxView({ model })
  const renderedView = view.render()
  expect(view).toBe(renderedView)
  expect(html).toMatchSnapshot()
  expect(render).toHaveBeenCalledWith("htmlTemplate", view.el)
})