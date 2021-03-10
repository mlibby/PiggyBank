class PiggyBank::Tax::Data::Form1099
  FIELDS = [
    :payer, :payer_id, :paid
  ]

  attr_accessor *FIELDS
end
