Sequel.seed do
  def run
    PiggyBank::Setting.create name: "commodity",
                              value: "USD",
                              version: PiggyBank::Repo.timestamp

    PiggyBank::Setting.create name: "locale",
                              value: "en-US",
                              version: PiggyBank::Repo.timestamp
  end
end
