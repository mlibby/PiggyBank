def seed_tx
  checking = PiggyBank::Account.find(name: "Free Checking")
  equity = PiggyBank::Account.find(name: "Equity")

  tx = PiggyBank::Tx.create post_date: "2021-01-23",
                            number: 1,
                            description: "Opening Balance"
  tx.add_split PiggyBank::Split.new memo: "",
                                    account_id: checking.account_id,
                                    value: 12.34,
                                    amount: 12.34
  tx.add_split PiggyBank::Split.new memo: "",
                                    account_id: equity.account_id,
                                    value: -12.34,
                                    amount: -12.34
  tx.save
end
