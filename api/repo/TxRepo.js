const newSplit = exports.newSplit = (tx, row) => {
  const split = {
    splitId: row.splitId,
    accountId: row.accountId,
    commodityId: row.commodityId,
    memo: row.memo,
    amount: row.amount,
    value: row.value,
    version: row.splitVersion
  }
  tx.splits.push(split)
}

const newTx = exports.newTx = (row) => {
  const tx = {
    id: row.txId,
    postDate: row.postDate,
    number: row.number,
    description: row.description,
    version: row.txVersion,
    splits: []
  }
  newSplit(tx, row)
  return tx
}

exports.TxRepo = class TxRepo {
  constructor(db) {
    this.db = db
  }

  selectAll() {
    const stmt = this.db.prepare(`
      SELECT
        t."txId",
        t."postDate",
        t."number",
        t."description",
        t."version" "txVersion"
        s."splitId",
        s."accountId",
        s."commodityId",
        s."memo",
        s."amount",
        s."value",
        s."version" "splitVersion"
      FROM tx t
      JOIN split s
      ON t."txId = s."txId"
      ORDER BY t."txId", s."splitId"
      `)

    const list = stmt.all()
    const txes = []
    let tx = { id: 0 }
    list.forEach((row) => {
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