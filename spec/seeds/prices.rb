def seed_prices
  usd = PiggyBank::Commodity.find(name: "USD")
  jpy = PiggyBank::Commodity.find(name: "JPY")

  PiggyBank::Price.create quote_date: "2021-01-24",
                          currency_id: usd.commodity_id,
                          commodity_id: jpy.commodity_id,
                          value: BigDecimal("12.34")
end
