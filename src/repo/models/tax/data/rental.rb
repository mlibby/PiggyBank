class PiggyBank::Tax::Data::Rental
  FIELDS = [
    :physical_address,
    :property_type,
    :fair_rental_days,
    :personal_days,
    :qualified_joint_venture,
    :rents_received,
    :royalties_received,
    :advertising,
    :auto,
    :cleaning,
    :commissions,
    :insurance,
    :legal_fees,
    :management_fees,
    :mortgage_interest,
    :other_interest,
    :repairs,
    :supplies,
    :taxes,
    :utilities,
    :depreciation,
    :other_desc,
    :other_amount
  ]

  attr_accessor *FIELDS
end
