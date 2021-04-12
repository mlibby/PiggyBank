class PiggyBank::Tax::Data::Form1099Int
  FIELDS = [
    :payer, :payer_id, :paid
  ]

  attr_accessor *FIELDS
end
