def seed_commodities
  PiggyBank::Commodity.create type: PiggyBank::Commodity::COMMODITY_TYPE[:currency],
                              name: "USD",
                              description: "US Dollar",
                              ticker: "USD",
                              fraction: 100

  PiggyBank::Commodity.create type: PiggyBank::Commodity::COMMODITY_TYPE[:currency],
                              name: "JPY",
                              description: "Japanese Yen",
                              ticker: "JPY",
                              fraction: 1

  PiggyBank::Commodity.create type: PiggyBank::Commodity::COMMODITY_TYPE[:currency],
                              name: "CAD",
                              description: "Canadian Dollar",
                              ticker: "CAD",
                              fraction: 100
end
