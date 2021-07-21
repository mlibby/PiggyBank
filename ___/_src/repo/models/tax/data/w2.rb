class PiggyBank::Tax::Data::W2
  FIELDS = [
    :ssn, :ein, :employer,
    :wages, :fed_wh,
    :soc_sec_wages, :soc_sec_wh,
    :medicare_wages, :medicare_taxes,
    :soc_sec_tips, :allocated_tips,
    :box_9, :dep_care_benefits,
    :nonqual_plans,
    :code_12a, :box_12a,
    :code_12b, :box_12b,
    :code_12c, :box_12c,
    :code_12d, :box_12d,
    :statutory_employee,
    :retirement_plan,
    :sick_pay,
    :other,
    :state, :state_ein,
    :state_wages,
    :state_tax,
    :local_wages,
    :local_tax,
    :locality,
  ]

  attr_accessor *FIELDS

  def statutory_employee=(val)
    @statutory_employee = !val.nil?
  end

  def retirement_plan=(val)
    @retirement_plan = !val.nil?
  end

  def sick_pay=(val)
    @sick_pay = !val.nil?
  end
end
