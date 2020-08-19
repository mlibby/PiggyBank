import { mockAccountAssets } from "../../__tests__/testHelpers"
import { AccountFormView } from "../AccountFormView"
import { AccountModel } from "../AccountModel"

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

test(".save updates the model, closes the form and triggers the 'saved' event", () => {
  const preventDefault = jest.fn()

  view.render()
  view.save({ preventDefault })
})