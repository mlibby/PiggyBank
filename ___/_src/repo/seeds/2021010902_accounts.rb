Sequel.seed do
  def run
    PiggyBank::Account.create parent_id: nil,
                              commodity_id: 1,
                              name: "Assets",
                              is_placeholder: true,
                              type: PiggyBank::Account::TYPE[:asset],
                              type_data: "",
                              version: PiggyBank::Repo.timestamp

    PiggyBank::Account.create parent_id: nil,
                              commodity_id: 1,
                              name: "Liabilities",
                              is_placeholder: true,
                              type: PiggyBank::Account::TYPE[:liability],
                              type_data: "",
                              version: PiggyBank::Repo.timestamp

    PiggyBank::Account.create parent_id: nil,
                              commodity_id: 1,
                              name: "Equity",
                              is_placeholder: true,
                              type: PiggyBank::Account::TYPE[:equity],
                              type_data: "",
                              version: PiggyBank::Repo.timestamp

    PiggyBank::Account.create parent_id: nil,
                              commodity_id: 1,
                              name: "Income",
                              is_placeholder: true,
                              type: PiggyBank::Account::TYPE[:income],
                              type_data: "",
                              version: PiggyBank::Repo.timestamp

    PiggyBank::Account.create parent_id: nil,
                              commodity_id: 1,
                              name: "Expense",
                              is_placeholder: true,
                              type: PiggyBank::Account::TYPE[:expense],
                              type_data: "",
                              version: PiggyBank::Repo.timestamp
  end
end
