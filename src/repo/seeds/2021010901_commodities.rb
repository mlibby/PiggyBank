Sequel.seed do
  def run
    Piggy::Commodity.create \
      type: Piggy::Commodity::CURRENCY,
      name: "USD",
      description: "US Dollar",
      ticker: "USD",
      fraction: 100,
      version: Piggy::Bank.new_version
  end
end
