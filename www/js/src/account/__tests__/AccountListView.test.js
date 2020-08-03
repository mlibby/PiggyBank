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
import { AccountListView } from "../AccountListView"

test("AccountListView has render method", () => {
  const model = {
    get: jest.fn()
  }
  const collection = [model]
  const view = new AccountListView({ collection })
  const renderedView = view.render()
  expect(view).toBe(renderedView)
  expect(html).toMatchSnapshot()
  // hmmm. render is only actually called by subviews, so how to test?
  //expect(render).toHaveBeenCalledWith("htmlTemplate", view.el)
})