def seed_commodities
  PiggyBank::Commodity.create type: PiggyBank::Commodity::COMMODITY_TYPE[:currency],
                              name: "USD",
                              description: "US Dollar",
                              ticker: "USD",
                              fraction: 100,
                              version: PiggyBank::Repo.timestamp
end
