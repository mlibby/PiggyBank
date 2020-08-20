import { mock$ } from "../../__tests__/testHelpers"
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
  const preventDefault = jest.fn()
  view.save({ preventDefault })

  expect(view.saved).toHaveBeenCalled()
})