import "../../__tests__/testHelpers"
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
  expect(view.el).toMatchSnapshot()
})

test("edit button triggers account:edit event", () => {
  const mockEdit = jest.fn()
  view.on("account:edit", mockEdit)

  view.render()
  view.$(".btn.edit").click()
  expect(mockEdit).toHaveBeenCalledWith(view.model)
})