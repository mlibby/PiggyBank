def seed_api_keys
  PiggyBank::ApiKey.create description: "alphavantage",
                           value: "a1b2c3"
end
