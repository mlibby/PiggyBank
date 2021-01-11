import { mockApiKeys } from "../../__tests__/testHelpers"
import { ApiKeyIndexView } from "../ApiKeyIndexView"

let view
beforeEach(() => {
  view = new ApiKeyIndexView()
})

test("ApiKeyIndexView.fetchSuccess() builds table of models from collection", () => {
  const mockAppend = jest.fn()
  view.$el.find = jest.fn(() => {
    return {
      append: mockAppend
    }
  })

  view.fetchSuccess(mockApiKeys)

  expect(view.$el.find).toHaveBeenCalledWith("table")
  expect(mockAppend).toHaveBeenCalled()
})
