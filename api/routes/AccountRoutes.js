class AccountRoutes {
  constructor(router, repo) {
    this.repo = repo
    this.router = router

    this.router.get("/", this.list.bind(this))
    this.router.post("/", this.create.bind(this))
    this.router.put("/:id", this.update.bind(this))
    this.router.delete("/", this.delete.bind(this))
  }

  async list(req, res, next) {
    const accounts = await this.repo.account.selectAll()
    res.json(accounts)
  }

  async create(req, res, next) {
    let account = this.requestToAccount(req)
    account = await this.repo.account.insert(account)
    res.json(account)
  }

  async update(req, res, next) {
    let account = this.requestToAccount(req)
    account = await this.repo.account.update(account)
    res.json(account)
  }

  async delete(req, res, next) {
    let account = this.requestToAccount(req)
    account = await this.repo.account.delete(account)
    res.status(200).json({})
  }

  requestToAccount(req) {
    const account = {
      name: req.fields.name,
      currencyId: req.fields.currencyId,
      isPlaceholder: req.fields.isPlaceholder,
      parentId: Number(req.fields.parentId)
    }

    if(req.fields.accountId) {
      account.accountId = req.fields.accountId,
      account.md5 = req.fields.md5
    }

    return account
  }
}

module.exports = AccountRoutes