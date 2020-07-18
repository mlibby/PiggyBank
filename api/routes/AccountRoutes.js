class AccountRoutes {
  constructor(router, repo) {
    this.repo = repo;
    router.get("/", this.list.bind(this));
    router.post("/", this.create.bind(this));
    router.put("/:id", this.update.bind(this));
    router.delete("/", this.delete.bind(this));
  }

  async list(req, res, next) {
    const accounts = await this.repo.account.selectAll();
    res.json(accounts);
  }

  async create(req, res, next) {

  }

  async update(req, res, next) {

  }

  async delete(req, res, next) {

  }
}

module.exports = AccountRoutes;