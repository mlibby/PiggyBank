import { TxModel } from "../TxModel"

test("TxModel configuration", () => {
  const model = new TxModel()
  expect(model.idAttribute).toBe("txId")
  expect(model.urlRoot).toBe("/api/tx")
})