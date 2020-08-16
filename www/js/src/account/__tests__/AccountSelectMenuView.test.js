import "../../__tests__/testHelpers"
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
  expect(view.el).toMatchSnapshot()
})