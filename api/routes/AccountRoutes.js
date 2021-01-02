"use strict"

exports.AccountRoutes = class AccountRoutes {
  constructor(router, repo) {
    this.repo = repo
    this.router = router

    this.router.get("/", this.list.bind(this))
    this.router.post("/", this.create.bind(this))
    this.router.put("/:id", this.update.bind(this))
    this.router.delete("/", this.delete.bind(this))
  }

  list(req, res, next) {
    const accounts = this.repo.account.selectAll()
    res.json(accounts)
  }

  create(req, res, next) {
    let account = this.requestToAccount(req)
    account = this.repo.account.insert(account)
    res.json(account)
  }

  update(req, res, next) {
    let account = this.requestToAccount(req)
    account = this.repo.account.update(account)
    res.json(account)
  }

  delete(req, res, next) {
    let account = this.requestToAccount(req)
    account = this.repo.account.delete(account)
    res.status(200).json({})
  }

  requestToAccount(req) {
    const account = {
      parentId: Number(req.fields.parentId),
      commodityId: req.fields.commodityId,
      name: req.fields.name,
      isPlaceholder: req.fields.isPlaceholder,
      type: req.fields.type,
      typeData: req.fields.typeData
    }

    if (req.fields.id) {
      account.id = req.fields.id,
        account.version = req.fields.version
    }

    return account
  }
}
