import { CommodityCollection } from "../CommodityCollection"
import { CommodityModel } from "../CommodityModel"

test("CommodityCollection configuration", () => {
  const collection = new CommodityCollection()
  expect(collection.model).toBe(CommodityModel)
  expect(collection.url).toBe("/api/commodity")
  expect(collection.comparator).toBe("name")
})