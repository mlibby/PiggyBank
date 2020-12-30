import { mockApiKeys } from "../../__tests__/testHelpers"
import { ApiKeyIndexView } from "../ApiKeyIndexView"

let view
beforeEach(() => {
  view = new ApiKeyIndexView()
})

test("ApiKeyIndexView.fetchSuccess() builds table of models from collection", () => {
  view.fetchSuccess(mockApiKeys)
  expect(false).toBe(true)
})
