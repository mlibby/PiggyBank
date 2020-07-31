import { getUuid } from "../PiggyBankUtil"

test("getUuid())", () => {
  const guid = getUuid()
  expect(guid.length).toBe(36)
})