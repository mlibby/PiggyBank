import { CommodityModel } from "../CommodityModel"

test("CommodityModel  configuration", () => {
  const model = new CommodityModel()
  expect(model.urlRoot).toBe("/api/commodity")
})