const { OfxRepo } = require("../OfxRepo")
const helpers = require("../../__tests__/testHelpers.js")
let queryFn = jest.fn()

test("new CommodityRepo(queryFn)", () => {
  const repo = new OfxRepo(queryFn)
  expect(repo.queryFn).toBe(queryFn)
})

test("selectAll() uses correct SQL and returns rows", async () => {
  const results = { rows: ["foo", "bar"] }
  queryFn.mockResolvedValue(results)
  const repo = new OfxRepo(queryFn)
  const ofx = await repo.selectAll()
  expect(helpers.normalize(queryFn.mock.calls[0][0]))
    .toBe(helpers.normalize(`
      SELECT
        ofx_id "ofxId",
        active,
        account_id "accountId",
        url,
        "user" "user",
        password,
        fid,
        fid_org "fidOrg",
        bank_id "bankId",
        acct_id "acctId",
        acct_type "acctType"
      FROM ofx`
    ))
  expect(ofx).toEqual(results.rows)
})