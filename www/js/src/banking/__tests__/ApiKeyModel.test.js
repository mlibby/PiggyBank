import { ApiKeyModel } from "../ApiKeyModel"

test("ApiKey model configuration", () => {
  const model = new ApiKeyModel()
  expect(model.idAttribute).toBe("apiKeyId")
  expect(model.urlRoot).toBe("/api/apiKey")
})