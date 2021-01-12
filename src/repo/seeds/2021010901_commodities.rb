Sequel.seed do
  def run
    repo = PiggyBank::Repo.new "sqlite://piggybank.sqlite"
    repo.commodities.create type: PiggyBank::Commodity::CURRENCY,
                            name: "USD",
                            description: "US Dollar",
                            ticker: "USD",
                            fraction: 100,
                            version: PiggyBank::Repo.timestamp
  end
end
