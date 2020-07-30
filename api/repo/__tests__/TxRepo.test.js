const { TxRepo } = require("../TxRepo")
const helpers = require("../../__tests__/testHelpers.js")
let queryFn = jest.fn()

test("new TxRepo(queryFn)", () => {
  const repo = new TxRepo(queryFn)
  expect(repo.queryFn).toBe(queryFn)
})

test("txRepo.selectAll() uses correct SQL and returns rows", async () => {
  const results = {
    rows: [
      {
        txId: 2,
        postDate: "2020-02-20",
        number: "345",
        description: "Foo Bar",
        splitId: 1,
        accountId: 10,
        commodityId: 2,
        memo: "Foo",
        amount: 22.22,
        value: 66.66
      },
      {
        txId: 2,
        postDate: "2020-02-20",
        number: "345",
        description: "Foo Bar",
        splitId: 2,
        accountId: 9,
        commodityId: 1,
        memo: "Bar",
        amount: -66.66,
        value: -66.66
      }
    ]
  }
  queryFn.mockResolvedValue(results)

  const repo = new TxRepo(queryFn)
  const tx = await repo.selectAll()

  expect(helpers.normalize(queryFn.mock.calls[0][0]))
    .toBe(helpers.normalize(`
      SELECT
        t.tx_id "txId",
        t.post_date "postDate",
        t.number,
        t.description,
        s.split_id "splitId",
        s.account_id "accountId",
        s.commodity_id "commodityId",
        s.memo,
        s.amount,
        s.value
      FROM tx t
      JOIN split s
      ON t.tx_id = s.tx_id
      ORDER BY t.tx_id, s.split_id`
    ))

  expect(tx.length).toBe(1)
  expect(tx[0].id).toBe(2)
  expect(tx[0].postDate).toBe("2020-02-20")
  expect(tx[0].description).toBe("Foo Bar")
  expect(tx[0].splits.length).toBe(2)
  expect(tx[0].splits).toContainEqual({
    splitId: 2,
    accountId: 9,
    commodityId: 1,
    memo: "Bar",
    amount: -66.66,
    value: -66.66
  })
  expect(tx[0].splits).toContainEqual({
    splitId: 1,
    accountId: 10,
    commodityId: 2,
    memo: "Foo",
    amount: 22.22,
    value: 66.66
  })
})