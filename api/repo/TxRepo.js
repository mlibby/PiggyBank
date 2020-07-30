const newSplit = exports.newSplit = (tx, row) => {
  const split = {
    splitId: row.splitId,
    accountId: row.accountId,
    commodityId: row.commodityId,
    memo: row.memo,
    amount: row.amount,
    value: row.value
  }
  tx.splits.push(split)
}

const newTx = exports.newTx = (row) => {
  const tx = {
    id: row.txId,
    postDate: row.postDate,
    number: row.number,
    description: row.description,
    splits: []
  }
  newSplit(tx, row)
  return tx
}

exports.TxRepo = class TxRepo {
  constructor(queryFn) {
    this.queryFn = queryFn
  }

  async selectAll() {
    const sql = `
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
      ORDER BY t.tx_id, s.split_id
      `

    const list = await this.queryFn(sql)
    const txes = []
    let tx = { id: 0 }
    list.rows.forEach((row) => {
      if (row.txId === tx.id) {
        newSplit(tx, row)
      }
      else {
        tx = newTx(row)
        txes.push(tx)
      }
    })

    return txes
  }
}