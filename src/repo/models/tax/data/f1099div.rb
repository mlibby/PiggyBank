class PiggyBank::Tax::Data::Form1099Div
  FIELDS = [
    :payer, :payer_id, :account_number, :ordinary_dividends, :qualified_dividends
  ]

  attr_accessor *FIELDS
end
