import "../../__tests__/testHelpers"
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
  expect(view.el).toMatchSnapshot()
})