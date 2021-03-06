require_relative "../base"

module PiggyBank; end
module PiggyBank::Tax; end
module PiggyBank::Tax::Form; end
module PiggyBank::Tax::Form::Writer; end
module PiggyBank::Tax::Form::Writer::US; end

class PiggyBank::Tax::Form::Writer::US::Form1040 < PiggyBank::Tax::Form::Writer::Base
  def initialize
    @template = "src/lib/tax/form/pdf/2020/us/f1040.pdf"
    super
    @adapter = PiggyBank::Tax::Form::Adapter::US::Form1040.instance
  end

  private

  def ssn_fields
    [
      "topmostSubform[0].Page1[0].YourSocial[0].f1_04[0]",
      "topmostSubform[0].Page1[0].SpousesSocial[0].f1_07[0]",
      "topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow1[0].f1_17[0]",
      "topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow2[0].f1_20[0]",
      "topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow3[0].f1_23[0]",
      "topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow4[0].f1_26[0]",
    ]
  end

  def text_fields
    {
      "topmostSubform[0].Page1[0].f1_02[0]" => @adapter.first_name,
      "topmostSubform[0].Page1[0].f1_03[0]" => @adapter.last_name,
      "topmostSubform[0].Page1[0].YourSocial[0].f1_04[0]" => @format.as_1040_ssn(@adapter.ssn),
      "topmostSubform[0].Page1[0].f1_05[0]" => @adapter.spouse_first_name,
      "topmostSubform[0].Page1[0].f1_06[0]" => @adapter.spouse_last_name,
      "topmostSubform[0].Page1[0].SpousesSocial[0].f1_07[0]" => @format.as_1040_ssn(@adapter.spouse_ssn),
      "topmostSubform[0].Page1[0].Address[0].f1_08[0]" => @adapter.street,
      "topmostSubform[0].Page1[0].Address[0].f1_09[0]" => @adapter.apt_no,
      "topmostSubform[0].Page1[0].Address[0].f1_10[0]" => @adapter.city,
      "topmostSubform[0].Page1[0].Address[0].f1_11[0]" => @adapter.state,
      "topmostSubform[0].Page1[0].Address[0].f1_12[0]" => @adapter.zip,
      "topmostSubform[0].Page1[0].Address[0].f1_13[0]" => @adapter.country,
      "topmostSubform[0].Page1[0].Address[0].f1_14[0]" => @adapter.province,
      "topmostSubform[0].Page1[0].Address[0].f1_15[0]" => @adapter.post_code,
      "topmostSubform[0].Page2[0].RoutingNo[0].f2_25[0]" => @format.as_1040_banking(@adapter.line_35b),
      "topmostSubform[0].Page2[0].AccountNo[0].f2_26[0]" => @format.as_1040_banking(@adapter.line_35d),
      "topmostSubform[0].Page2[0].f2_36[0]" => @adapter.occupation,
      "topmostSubform[0].Page2[0].f2_38[0]" => @adapter.spouse_occupation,
      "topmostSubform[0].Page2[0].f2_40[0]" => @adapter.contact_phone,
      "topmostSubform[0].Page2[0].f2_41[0]" => @adapter.contact_email,
    }
  end

  def money_fields
    {
      "topmostSubform[0].Page1[0].Lines1-11_ReadOrder[0].f1_28[0]" => @format.as_currency(@adapter.line_1),
      "topmostSubform[0].Page1[0].Lines1-11_ReadOrder[0].f1_30[0]" => @format.as_currency(@adapter.line_2b),
      "topmostSubform[0].Page1[0].Lines1-11_ReadOrder[0].f1_31[0]" => @format.as_currency(@adapter.line_3a),
      "topmostSubform[0].Page1[0].Lines1-11_ReadOrder[0].f1_32[0]" => @format.as_currency(@adapter.line_3b),
      "topmostSubform[0].Page1[0].Lines1-11_ReadOrder[0].f1_40[0]" => @format.as_currency(@adapter.line_8),
      "topmostSubform[0].Page1[0].Lines1-11_ReadOrder[0].f1_41[0]" => @format.as_currency(@adapter.line_9),
      "topmostSubform[0].Page1[0].Lines1-11_ReadOrder[0].f1_45[0]" => @format.as_currency(@adapter.line_11),
      "topmostSubform[0].Page1[0].f1_46[0]" => @format.as_currency(@adapter.line_12),
      "topmostSubform[0].Page1[0].f1_47[0]" => @format.as_currency(@adapter.line_13),
      "topmostSubform[0].Page1[0].f1_48[0]" => @format.as_currency(@adapter.line_14),
      "topmostSubform[0].Page1[0].f1_49[0]" => @format.as_currency(@adapter.line_15),
      "topmostSubform[0].Page2[0].f2_02[0]" => @format.as_currency(@adapter.line_16),
      "topmostSubform[0].Page2[0].f2_03[0]" => @format.as_currency(@adapter.line_17),
      "topmostSubform[0].Page2[0].f2_04[0]" => @format.as_currency(@adapter.line_18),
      "topmostSubform[0].Page2[0].f2_05[0]" => @format.as_currency(@adapter.line_19),
      "topmostSubform[0].Page2[0].f2_06[0]" => @format.as_currency(@adapter.line_20),
      "topmostSubform[0].Page2[0].f2_07[0]" => @format.as_currency(@adapter.line_21),
      "topmostSubform[0].Page2[0].f2_08[0]" => @format.as_currency(@adapter.line_22),
      "topmostSubform[0].Page2[0].f2_09[0]" => @format.as_currency(@adapter.line_23),
      "topmostSubform[0].Page2[0].f2_10[0]" => @format.as_currency(@adapter.line_24),
      "topmostSubform[0].Page2[0].Line25_ReadOrder[0].f2_11[0]" => @format.as_currency(@adapter.line_25a),
      "topmostSubform[0].Page2[0].Line25_ReadOrder[0].f2_12[0]" => @format.as_currency(@adapter.line_25b),
      "topmostSubform[0].Page2[0].Line25_ReadOrder[0].f2_13[0]" => @format.as_currency(@adapter.line_25c),
      "topmostSubform[0].Page2[0].Lines26-27_ReadOrder[0].f2_14[0]" => @format.as_currency(@adapter.line_25d),
      "topmostSubform[0].Page2[0].Lines26-27_ReadOrder[0].f2_15[0]" => @format.as_currency(@adapter.line_26),
      "topmostSubform[0].Page2[0].Lines27-32_ReadOrder[0].f2_16[0]" => @format.as_currency(@adapter.line_27),
      "topmostSubform[0].Page2[0].Lines27-32_ReadOrder[0].f2_17[0]" => @format.as_currency(@adapter.line_28),
      "topmostSubform[0].Page2[0].Lines27-32_ReadOrder[0].f2_18[0]" => @format.as_currency(@adapter.line_29),
      "topmostSubform[0].Page2[0].Lines27-32_ReadOrder[0].f2_19[0]" => @format.as_currency(@adapter.line_30),
      "topmostSubform[0].Page2[0].Lines27-32_ReadOrder[0].f2_20[0]" => @format.as_currency(@adapter.line_31),
      "topmostSubform[0].Page2[0].Line32-33_ReadOrder[0].f2_21[0]" => @format.as_currency(@adapter.line_32),
      "topmostSubform[0].Page2[0].f2_22[0]" => @format.as_currency(@adapter.line_33),
      "topmostSubform[0].Page2[0].f2_23[0]" => @format.as_currency(@adapter.line_34),
      "topmostSubform[0].Page2[0].f2_24[0]" => @format.as_currency(@adapter.line_35a),
      "topmostSubform[0].Page2[0].f2_28[0]" => @format.as_currency(@adapter.line_37),
    }
  end

  def dependent_fields
    df = { text: {}, button: {} }
    unless @adapter.dependents[0].nil?
      df[:text]["topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow1[0].f1_16[0]"] = @adapter.dependents[0].name
      df[:text]["topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow1[0].f1_17[0]"] = @format.as_1040_ssn(@adapter.dependents[0].ssn)
      df[:text]["topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow1[0].f1_18[0]"] = @adapter.dependents[0].relation
      df[:button]["topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow1[0].c1_13[0]"] = @adapter.dependents[0].child_credit
      df[:button]["topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow1[0].c1_14[0]"] = @adapter.dependents[0].other_credit
    end
    unless @adapter.dependents[1].nil?
      df[:text]["topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow2[0].f1_19[0]"] = @adapter.dependents[1].name
      df[:text]["topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow2[0].f1_20[0]"] = @format.as_1040_ssn(@adapter.dependents[1].ssn)
      df[:text]["topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow2[0].f1_21[0]"] = @adapter.dependents[1].relation
      df[:button]["topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow2[0].c1_15[0]"] = @adapter.dependents[1].child_credit
      df[:button]["topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow2[0].c1_16[0]"] = @adapter.dependents[1].other_credit
    end
    unless @adapter.dependents[2].nil?
      df[:text]["topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow3[0].f1_22[0]"] = @adapter.dependents[2].name
      df[:text]["topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow3[0].f1_23[0]"] = @format.as_1040_ssn(@adapter.dependents[2].ssn)
      df[:text]["topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow3[0].f1_24[0]"] = @adapter.dependents[2].relation
      df[:button]["topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow3[0].c1_17[0]"] = @adapter.dependents[2].child_credit
      df[:button]["topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow3[0].c1_18[0]"] = @adapter.dependents[2].other_credit
    end
    unless @adapter.dependents[3].nil?
      df[:text]["topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow4[0].f1_25[0]"] = @adapter.dependents[3].name
      df[:text]["topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow4[0].f1_26[0]"] = @format.as_1040_ssn(@adapter.dependents[3].ssn)
      df[:text]["topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow4[0].f1_27[0]"] = @adapter.dependents[3].relation
      df[:button]["topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow4[0].c1_19[0]"] = @adapter.dependents[3].child_credit
      df[:button]["topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow4[0].c1_20[0]"] = @adapter.dependents[3].other_credit
    end
    df
  end

  def button_fields
    {
      "topmostSubform[0].Page1[0].FilingStatus[0].c1_01[0]" => @adapter.single?,
      "topmostSubform[0].Page1[0].FilingStatus[0].c1_01[1]" => @adapter.married_joint?,
      "topmostSubform[0].Page1[0].FilingStatus[0].c1_01[2]" => @adapter.married_separately?,
      "topmostSubform[0].Page1[0].FilingStatus[0].c1_01[3]" => @adapter.head_of_household?,
      "topmostSubform[0].Page1[0].FilingStatus[0].c1_01[4]" => @adapter.qualified_widow?,
      "topmostSubform[0].Page1[0].c1_02[0]" => @adapter.campaign?,
      "topmostSubform[0].Page1[0].c1_03[0]" => @adapter.spouse_campaign?,
      "topmostSubform[0].Page1[0].c1_04[0]" => @adapter.virtual_currency?,
      "topmostSubform[0].Page1[0].c1_04[1]" => !@adapter.virtual_currency?,
      "topmostSubform[0].Page1[0].c1_08[0]" => @adapter.born_before_19560102?,
      "topmostSubform[0].Page1[0].c1_09[0]" => @adapter.blind?,
      "topmostSubform[0].Page1[0].c1_10[0]" => @adapter.spouse_born_before_19560102?,
      "topmostSubform[0].Page1[0].c1_11[0]" => @adapter.spouse_blind?,
      "topmostSubform[0].Page1[0].Dependents_ReadOrder[0].c1_12[0]" => @adapter.more_than_four_deps?,
      "topmostSubform[0].Page2[0].c2_05[0]" => @adapter.line_35c == "checking",
      "topmostSubform[0].Page2[0].c2_05[1]" => @adapter.line_35d == "savings",

    }
  end

  def draw_fields
    fix_ssn_fields
    set_field_values text_fields
    set_field_values dependent_fields[:text]
    set_field_values button_fields
    set_field_values dependent_fields[:button]
    set_field_values money_fields
  end

  def fix_ssn_fields
    ssn_fields.each do |name|
      ssn = @fields.find { |f| f.full_field_name == name }
      raise "Cannot find PDF field #{name}" if ssn.nil?
      ssn.unflag(:comb)
      ssn.text_alignment(:center)
    end
  end
end
