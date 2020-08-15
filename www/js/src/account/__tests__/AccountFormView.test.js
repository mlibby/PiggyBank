import { mockTemplate } from "../../__tests__/testHelpers"
import { html, render } from "../../../lib/lit-html/lit-html.js"
import { AccountFormView } from "../AccountFormView"
import { AccountModel } from "../AccountModel"

let view
beforeEach(() => {
  const account = new AccountModel({
    id: 1,
    currencyId: 1,
    name: "Assets",
    isPlaceholder: 1,
    parentId: null
  })
  view = new AccountFormView({model: account})
})

test("AccountFormView has render method", () => {
  const renderedView = view.render()
  expect(view).toBe(renderedView)
  expect(html).toMatchSnapshot()
  expect(render).toHaveBeenCalledWith(mockTemplate, view.el)
})