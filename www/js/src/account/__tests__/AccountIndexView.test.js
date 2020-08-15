import { mockTemplate } from "../../__tests__/testHelpers"
import { html, render } from "../../../lib/lit-html/lit-html.js"
import { AccountIndexView } from "../AccountIndexView"

let view
beforeEach(() => {
  view = new AccountIndexView()
  view.listView = {
    on: jest.fn(),
    render: jest.fn().mockReturnValue("list view")
  }
})

test("AccountView has render method", () => {
  const renderedView = view.render()
  expect(view).toBe(renderedView)
  expect(html).toMatchSnapshot()
  expect(render).toHaveBeenCalledWith(mockTemplate, view.el)
})