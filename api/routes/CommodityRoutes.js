"use strict"

exports.CommodityRoutes = class CommodityRoutes {
  constructor(router, repo) {
    this.repo = repo
    this.router = router

    this.router.get("/", this.list.bind(this))
    this.router.post("/", this.create.bind(this))
    // this.router.put("/:id", this.update.bind(this))
    // this.router.delete("/", this.delete.bind(this))
  }

  list(req, res, next) {
    const commodities = this.repo.commodity.selectAll()
    res.json(commodities)
  }

  create(req, res, next) {
    try {
      let commodity = this.requestToCommodity(req)
      commodity = this.repo.commodity.insert(commodity)
      res.json(commodity)
    }
    catch (err) {
      res.status(500)
      res.json({
        code: err.code,
        message: err.message
      })
    }
  }

  update(req, res, next) {
    let commodity = this.requestToCommodity(req)
    commodity = this.repo.commodity.update(commodity)
    res.json(commodity)
  }

  // async delete(req, res, next) {
  //   let account = this.requestToAccount(req)
  //   account = await this.repo.account.delete(account)
  //   res.status(200).json({})
  // }

  requestToCommodity(req) {
    const commodity = {
      name: req.fields.name,
      description: req.fields.description,
      type: req.fields.type,
      ticker: req.fields.ticker,
      fraction: req.fields.fraction
    }

    if (req.fields.id) {
      commodity.id = req.fields.id,
        commodity.version = req.fields.version
    }

    return commodity
  }

}
