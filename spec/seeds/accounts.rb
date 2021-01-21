def seed_accounts
  usd_id = PiggyBank::Commodity.find(name: "USD").commodity_id

  PiggyBank::Account.create parent_id: nil,
                            commodity_id: usd_id,
                            name: "Assets",
                            is_placeholder: true,
                            type: PiggyBank::Account::TYPE_CODE[:asset],
                            type_data: "",
                            version: PiggyBank::Repo.timestamp

  PiggyBank::Account.create parent_id: nil,
                            commodity_id: usd_id,
                            name: "Liabilities",
                            is_placeholder: true,
                            type: PiggyBank::Account::TYPE_CODE[:liability],
                            type_data: "",
                            version: PiggyBank::Repo.timestamp

  PiggyBank::Account.create parent_id: nil,
                            commodity_id: usd_id,
                            name: "Equity",
                            is_placeholder: true,
                            type: PiggyBank::Account::TYPE_CODE[:equity],
                            type_data: "",
                            version: PiggyBank::Repo.timestamp

  PiggyBank::Account.create parent_id: nil,
                            commodity_id: usd_id,
                            name: "Income",
                            is_placeholder: true,
                            type: PiggyBank::Account::TYPE_CODE[:income],
                            type_data: "",
                            version: PiggyBank::Repo.timestamp

  PiggyBank::Account.create parent_id: nil,
                            commodity_id: usd_id,
                            name: "Expense",
                            is_placeholder: true,
                            type: PiggyBank::Account::TYPE_CODE[:expense],
                            type_data: "",
                            version: PiggyBank::Repo.timestamp
end
