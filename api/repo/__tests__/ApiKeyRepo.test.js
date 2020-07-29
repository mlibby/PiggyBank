const ApiKeyRepo = require("../ApiKeyRepo")
const helpers = require("../../__tests__/testHelpers.js")
let queryFn = jest.fn()

test("new ApiKeyRepo(queryFn)", () => {
  const repo = new ApiKeyRepo(queryFn)
  expect(repo.queryFn).toBe(queryFn)
})

test("selectAll() uses correct SQL and returns rows", async () => {
  const results = { rows: ["foo", "bar"] }
  queryFn.mockResolvedValue(results)
  const repo = new ApiKeyRepo(queryFn)
  const apiKeys = await repo.selectAll()
  expect(helpers.normalize(queryFn.mock.calls[0][0]))
    .toBe(helpers.normalize(`
      SELECT
        api_key_id "id",
        description,
        api_key_value "apiKeyValue"
      FROM api_key`
    ))
  expect(apiKeys).toEqual(results.rows)
})