import { AccountListView } from "../AccountListView"

test("AccountListView has render method", () => {
  const model = {
    get: jest.fn()
  }
  const collection = [model]
  const view = new AccountListView({ collection })
  const renderedView = view.render()
  expect(view).toBe(renderedView)
  expect(view.el).toMatchSnapshot()
})