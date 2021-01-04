import { mock$ } from "../../__tests__/testHelpers"
import { CommodityCollection } from "../CommodityCollection"
import { CommodityFormView } from "../CommodityFormView"

let view
beforeEach(() => {
  view = new CommodityFormView({ model: window.piggybank.commodities.models[0] })
})

test("CommodityFormView has render method", () => {
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
  view.$ = mock$

  view.saved = jest.fn()
  view.model.save = jest.fn().mockImplementation((attr, opts) => {
    opts.success.call(view.model, 200, null)
  })

  view.render()

  const preventDefault = jest.fn()
  view.save({ preventDefault })
  expect(preventDefault).toHaveBeenCalled()

  // expect(view.$).toHaveBeenCalledWith("#accountName")
  // expect(mockVal).toHaveBeenCalled()
  // expect(view.$).toHaveBeenCalledWith("#isPlaceholder")
  // expect(mockChecked).toHaveBeenCalled()

  expect(view.model.save).toHaveBeenCalled()
})

test("failed .save calls saveError function", () => {
  view.$ = mock$

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
  view.saveError({}, { responseJSON: { message: "Yikes!" } }, {})

  expect(mockAlert).toHaveBeenCalledWith("error saving commodity: Yikes!")
})

test("saved(isNew=true) closes view and triggers saved event", () => {
  view.close = jest.fn()
  view.trigger = jest.fn()

  view.render()
  const mockModel = {}
  view.saved(true, mockModel)

  expect(view.close).toHaveBeenCalled()
  expect(view.trigger).toHaveBeenCalledWith("saved", mockModel)
})

test("saved(isNew=false) closes view and triggers created event", () => {
  view.close = jest.fn()
  view.trigger = jest.fn()

  view.render()
  const mockModel = {}
  view.saved(false, mockModel)

  expect(view.close).toHaveBeenCalled()
  expect(view.trigger).toHaveBeenCalledWith("created", mockModel)
})