import { mockTemplate } from "../../__tests__/testHelpers"
import { html, render } from "../../../lib/lit-html/lit-html.js"
import { AccountView } from "../AccountView"

let view
beforeEach(() => {
  view = new AccountView({ model: {
    get: jest.fn()
  } })
})

test("AccountView has render method", () => {
  const renderedView = view.render()
  expect(view).toBe(renderedView)
  expect(html).toMatchSnapshot()
  expect(render).toHaveBeenCalledWith(mockTemplate, view.el)
})

test("buttons trigger events", () => {

})