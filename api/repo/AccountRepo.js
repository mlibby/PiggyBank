class AccountRepo {
  constructor(queryFn) {
    this.queryFn = queryFn;
  }
}

module.exports = AccountRepo;