exports.OfxRepo = class OfxRepo {
  constructor(queryFn) {
    this.queryFn = queryFn
  }

  async selectAll() {
    const sql = `
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

    const results = await this.queryFn(sql)
    return results.rows
  }
}