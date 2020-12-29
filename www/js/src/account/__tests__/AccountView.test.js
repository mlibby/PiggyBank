import { mockAccountAssets } from "../../__tests__/testHelpers"
import { AccountView } from "../AccountView"

let view
beforeEach(() => {
  view = new AccountView({ model: mockAccountAssets })
})

test("AccountView has render method", () => {
  const renderedView = view.render()
  expect(view).toBe(renderedView)
  expect(view.el).toMatchSnapshot()
})

test("AccountView removes existing subview during render", () => {
  const renderedView = view.render()
  expect(renderedView.subview).toBeTruthy()

  const remove = jest.fn()
  view.subview.remove = remove
  view.render()

  expect(remove).toHaveBeenCalled()
})

test("edit button triggers account:edit event", () => {
  const mockEdit = jest.fn()
  view.on("account:edit", mockEdit)
  4
  view.render()
  view.$(".btn.edit").click()
  expect(mockEdit).toHaveBeenCalledWith(view.model)
})

test("delete button triggers account:delete event", () => {
  const mockDelete = jest.fn()
  view.on("account:delete", mockDelete)

  view.render()
  view.$(".btn.delete").click()
  expect(mockDelete).toHaveBeenCalledWith(view.model)
})

test("create button triggers account:create event", () => {
  const mockCreate = jest.fn()
  view.on("account:create", mockCreate)

  view.render()
  view.$(".btn.create").click()
  expect(mockCreate).toHaveBeenCalledWith(view.model)
})

test("when account is a placeholder, add placeholder to el", () => {
  view.$el.addClass = jest.fn()
  view.$el.removeClass = jest.fn()

  view.model.set("isPlaceholder", 1)
  view.render()

  expect(view.$el.addClass).toHaveBeenCalledWith("placeholder")
  expect(view.$el.removeClass).toHaveBeenCalledWith("account")
})

test("when account is not a placeholder, add account to el", () => {
  view.$el.addClass = jest.fn()
  view.$el.removeClass = jest.fn()

  view.model.set("isPlaceholder", 0)
  view.render()

  expect(view.$el.addClass).toHaveBeenCalledWith("account")
  expect(view.$el.removeClass).toHaveBeenCalledWith("placeholder")
})