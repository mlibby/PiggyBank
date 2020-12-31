"use strict"

exports.ApiKeyRoutes = class ApiKeyRoutes {
  constructor(router, repo) {
    this.repo = repo
    this.router = router

    this.router.get("/", this.list.bind(this))
    // this.router.post("/", this.create.bind(this))
    // this.router.put("/:id", this.update.bind(this))
    // this.router.delete("/", this.delete.bind(this))
  }

  list(req, res, next) {
    const apiKeys = this.repo.apiKey.selectAll()
    res.json(apiKeys)
  }

  // async create(req, res, next) {
  //   let account = this.requestToAccount(req)
  //   account = await this.repo.account.insert(account)
  //   res.json(account)
  // }

  update(req, res, next) {
    let apiKey = this.requestToApiKey(req)
    apiKey = this.repo.apiKey.update(apiKey)
    res.json(apiKey)
  }

  // async delete(req, res, next) {
  //   let account = this.requestToAccount(req)
  //   account = await this.repo.account.delete(account)
  //   res.status(200).json({})
  // }

  requestToApiKey(req) {
    const apiKey = {
      description: req.fields.description,
      apiKeyValue: req.fields.apiKeyValue
    }

    if(req.fields.apiKeyId) {
      apiKey.apiKeyId = req.fields.apiKeyId,
      apiKey.version = req.fields.version
    }

    return apiKey
  }
}
