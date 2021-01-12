Sequel.seed do
  def run
    repo = new PiggyBank::Repo.new "sqlite://piggybank.sqlite"
    repo.accounts.create parent_id: nil,
                         commodity_id: 1,
                         name: "Assets",
                         is_placeholder: true,
                         type: PiggyBank::Account::TYPE_ASSET,
                         type_data: "",
                         version: PiggyBank::Repo.timestamp

    repo.accounts.create parent_id: nil,
                         commodity_id: 1,
                         name: "Liabilities",
                         is_placeholder: true,
                         type: PiggyBank::Account::TYPE_LIABILITY,
                         type_data: "",
                         version: PiggyBank::Repo.timestamp

    repo.accounts.create parent_id: nil,
                         commodity_id: 1,
                         name: "Equity",
                         is_placeholder: true,
                         type: PiggyBank::Account::TYPE_EQUITY,
                         type_data: "",
                         version: PiggyBank::Repo.timestamp

    repo.accounts.create parent_id: nil,
                         commodity_id: 1,
                         name: "Income",
                         is_placeholder: true,
                         type: PiggyBank::Account::TYPE_INCOME,
                         type_data: "",
                         version: PiggyBank::Repo.timestamp

    repo.accounts.create parent_id: nil,
                         commodity_id: 1,
                         name: "Expense",
                         is_placeholder: true,
                         type: PiggyBank::Account::TYPE_EXPENSE,
                         type_data: "",
                         version: PiggyBank::Repo.timestamp
  end
end
