Sequel.seed do
  def run
    PiggyBank::Commodity.create type: PiggyBank::Commodity::CURRENCY,
                                name: "USD",
                                description: "US Dollar",
                                ticker: "USD",
                                fraction: 100,
                                version: PiggyBank::Repo.timestamp
  end
end
