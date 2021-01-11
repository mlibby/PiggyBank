import { mockEvent } from "../../__tests__/testHelpers"
import { ApiKeyView } from "../ApiKeyView"

let view

beforeEach(() => {
  const model = {
    get: jest.fn()
  }
  view = new ApiKeyView({ model })
})

test("ApiKeyView has render method", () => {
  const renderedView = view.render()
  expect(view).toBe(renderedView)
  expect(view.el).toMatchSnapshot()
})

test("ApiKeyView.edit() triggers 'apiKey:edit' event", () => {
  var eventTriggered = false
  view.render()
  view.on("apiKey:edit", () => {
    eventTriggered = true
  })
  view.edit(mockEvent)
  expect(mockEvent.preventDefault).toHaveBeenCalled()
  expect(eventTriggered).toBe(true)
})

test("ApiKeyView.delete() triggers 'apiKey:delete' event", () => {
  var eventTriggered = false
  view.render()
  view.on("apiKey:delete", () => {
    eventTriggered = true
  })
  view.delete(mockEvent)
  expect(mockEvent.preventDefault).toHaveBeenCalled()
  expect(eventTriggered).toBe(true)
})