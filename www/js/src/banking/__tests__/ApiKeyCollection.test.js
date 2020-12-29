import { mockApiKeys } from "../../__tests__/testHelpers"
import { ApiKeyModel } from "../ApiKeyModel"

test("new ApiKeyCollection()", () => {
  expect(mockApiKeys.model).toBe(ApiKeyModel)
  expect(mockApiKeys.url).toBe("/api/apiKey")
  expect(mockApiKeys.comparator).toBe("description")
})
