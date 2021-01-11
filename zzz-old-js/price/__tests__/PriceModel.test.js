import { PriceModel } from "../PriceModel"

test("account model configuration", () => {
  const model = new PriceModel()
  expect(model.urlRoot).toBe("/api/price")
})