import { mockTemplate } from "../../__tests__/TestHelpers"
import { html, render } from "../../../lib/lit-html/lit-html.js"
import { AccountSelectMenuView } from "../AccountSelectMenuView"
import { AccountCollection } from "../AccountCollection.js"

test("AccountSelectMenuView has render method", () => {
  const model = {
    get: jest.fn()
  }
  const collection = new AccountCollection({ models: [model] })
  const view = new AccountSelectMenuView({ collection })
  const renderedView = view.render()
  expect(view).toBe(renderedView)
  expect(html).toMatchSnapshot()
  expect(render).toHaveBeenCalledWith(mockTemplate, view.el)
})