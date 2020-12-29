import { mock$ } from "../../__tests__/testHelpers"
import { AccountCollection } from "../AccountCollection"
import { AccountFormView } from "../AccountFormView"

let view
beforeEach(() => {
  view = new AccountFormView({ model: window.piggybank.accounts.models[0] })
})

test("AccountFormView has render method", () => {
  const renderedView = view.render()
  expect(view).toBe(renderedView)
  expect(view.el).toMatchSnapshot()
})

test(".close hides the modal and destroys the view", () => {
  const modal = jest.fn()
  view.$ = jest.fn().mockReturnValue({ modal })

  view.close()

  expect(view.$).toHaveBeenCalledWith("#modalForm")
  expect(modal).toHaveBeenCalledWith("hide")
})

test(".cancel prevents default event action and calls .close", () => {
  view.close = jest.fn()
  const preventDefault = jest.fn()

  view.cancel({ preventDefault })

  expect(preventDefault).toHaveBeenCalled()
  expect(view.close).toHaveBeenCalled()
})

test("successful .save updates the model, closes the form and calls .saved", () => {
  view.$ = jest.fn().mockReturnValue(mock$)

  view.saved = jest.fn()
  view.model.save = jest.fn().mockImplementation((attr, opts) => {
    opts.success.call(view.model, 200, null)
  })

  view.render()
  view.commodityMenu.getSelectedId = jest.fn()
  view.parentMenu.getSelectedId = jest.fn()
  const mockVal = jest.fn()
  const mockZero = jest.fn()
  const mockChecked = jest.fn(() => true)
  Object.defineProperty(mockZero, "checked", {
    get: mockChecked,
    set: jest.fn()
  })
  view.$ = jest.fn().mockReturnValue({
    0: mockZero,
    val: mockVal
  })

  const preventDefault = jest.fn()
  view.save({ preventDefault })
  expect(preventDefault).toHaveBeenCalled()

  expect(view.commodityMenu.getSelectedId).toHaveBeenCalled()
  expect(view.parentMenu.getSelectedId).toHaveBeenCalled()
  expect(view.$).toHaveBeenCalledWith("#accountName")
  expect(mockVal).toHaveBeenCalled()
  expect(view.$).toHaveBeenCalledWith("#isPlaceholder")
  expect(mockChecked).toHaveBeenCalled()

  expect(view.saved).toHaveBeenCalled()
})

test("failed .save calls saveError function", () => {
  view.$ = jest.fn().mockReturnValue(mock$)

  view.saveError = jest.fn()
  view.model.save = jest.fn().mockImplementation((attr, opts) => {
    opts.error.call(view.model, 404, null)
  })

  view.render()
  const preventDefault = jest.fn()
  view.save({ preventDefault })

  expect(view.saveError).toHaveBeenCalled()
})

test("saveError alerts user about error", () => {
  const mockAlert = jest.fn()
  window.alert = mockAlert

  view.render()
  view.saveError()

  expect(mockAlert).toHaveBeenCalledWith("error saving account")
})

test("saved() adds child collection, closes view, and triggers saved event", () => {
  view.close = jest.fn()
  view.trigger = jest.fn()

  view.render()
  view.model.children = null
  view.saved()

  expect(view.close).toHaveBeenCalled()
  expect(view.trigger).toHaveBeenCalledWith("saved")
  expect(view.model.children).toBeInstanceOf(AccountCollection)
})