import { OfxModel } from "../OfxModel"

test("OfxModel configuration", () => {
  const model = new OfxModel()
  expect(model.urlRoot).toBe("/api/ofx")
})