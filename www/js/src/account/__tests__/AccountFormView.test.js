import { mockAccountAssets } from "../../__tests__/testHelpers"
import { AccountFormView } from "../AccountFormView"
import { AccountModel } from "../AccountModel"

let view
beforeEach(() => {
  view = new AccountFormView({ model: mockAccountAssets })
})

test("AccountFormView has render method", () => {
  const renderedView = view.render()
  expect(view).toBe(renderedView)
  expect(view.el).toMatchSnapshot()
})