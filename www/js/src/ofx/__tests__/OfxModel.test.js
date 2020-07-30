import { OfxModel } from "../OfxModel"

test("OfxModel configuration", () => {
  const model = new OfxModel()
  expect(model.idAttribute).toBe("ofxId")
  expect(model.urlRoot).toBe("/api/ofx")
})