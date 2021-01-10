import { mockAccounts } from "../../__tests__/testHelpers"
import { AccountListView } from "../AccountListView"

test("AccountListView has render method", () => {
  const view = new AccountListView({ collection: mockAccounts })
  const renderedView = view.render()
  expect(view).toBe(renderedView)
  expect(view.el).toMatchSnapshot()
})