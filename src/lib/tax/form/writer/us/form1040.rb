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
    @adapter = PiggyBank::Tax::Form::Adapter::US::Form1040.new
  end

  def write_form
    draw_fields
    write_pdf
  end

  private

  def text_fields
    {
      "topmostSubform[0].Page1[0].f1_02[0]" => @adapter.first_name,
      "topmostSubform[0].Page1[0].f1_03[0]" => @adapter.last_name,
      "topmostSubform[0].Page1[0].YourSocial[0].f1_04[0]" => @adapter.ssn,
      "topmostSubform[0].Page1[0].f1_05[0]" => @adapter.spouse_first_name,
      "topmostSubform[0].Page1[0].f1_06[0]" => @adapter.spouse_last_name,
      "topmostSubform[0].Page1[0].SpousesSocial[0].f1_07[0]" => @adapter.spouse_ssn,
      "topmostSubform[0].Page1[0].Address[0].f1_08[0]" => @adapter.street,
      "topmostSubform[0].Page1[0].Address[0].f1_09[0]" => @adapter.apt_no,
      "topmostSubform[0].Page1[0].Address[0].f1_10[0]" => @adapter.city,
      "topmostSubform[0].Page1[0].Address[0].f1_11[0]" => @adapter.state,
      "topmostSubform[0].Page1[0].Address[0].f1_12[0]" => @adapter.zip,
      "topmostSubform[0].Page1[0].Address[0].f1_13[0]" => @adapter.country,
      "topmostSubform[0].Page1[0].Address[0].f1_14[0]" => @adapter.province,
      "topmostSubform[0].Page1[0].Address[0].f1_15[0]" => @adapter.post_code,
    }
  end

  def money_fields
    {
      "topmostSubform[0].Page1[0].Lines1-11_ReadOrder[0].f1_28[0]" => @adapter.line_1,
    }
  end

  def dependent_fields
    df = { text: {}, button: {} }
    unless @adapter.dependents[0].nil?
      df[:text]["topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow1[0].f1_16[0]"] = @adapter.dependents[0].name
      df[:text]["topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow1[0].f1_17[0]"] = @adapter.dependents[0].ssn
      df[:text]["topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow1[0].f1_18[0]"] = @adapter.dependents[0].relation
      df[:button]["topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow1[0].c1_13[0]"] = @adapter.dependents[0].child_credit
      df[:button]["topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow1[0].c1_14[0]"] = @adapter.dependents[0].other_credit
    end
    unless @adapter.dependents[1].nil?
      df[:text]["topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow2[0].f1_19[0]"] = @adapter.dependents[1].name
      df[:text]["topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow2[0].f1_20[0]"] = @adapter.dependents[1].ssn
      df[:text]["topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow2[0].f1_21[0]"] = @adapter.dependents[1].relation
      df[:button]["topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow2[0].c1_15[0]"] = @adapter.dependents[1].child_credit
      df[:button]["topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow2[0].c1_16[0]"] = @adapter.dependents[1].other_credit
    end
    unless @adapter.dependents[2].nil?
      df[:text]["topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow3[0].f1_22[0]"] = @adapter.dependents[2].name
      df[:text]["topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow3[0].f1_23[0]"] = @adapter.dependents[2].ssn
      df[:text]["topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow3[0].f1_24[0]"] = @adapter.dependents[2].relation
      df[:button]["topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow3[0].c1_17[0]"] = @adapter.dependents[2].child_credit
      df[:button]["topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow3[0].c1_18[0]"] = @adapter.dependents[2].other_credit
    end
    unless @adapter.dependents[3].nil?
      df[:text]["topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow4[0].f1_25[0]"] = @adapter.dependents[3].name
      df[:text]["topmostSubform[0].Page1[0].Table_Dependents[0].BodyRow4[0].f1_26[0]"] = @adapter.dependents[3].ssn
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
      # "topmostSubform[0].Page1[0].c1_05[0]" => @general.dependent,
      # "topmostSubform[0].Page1[0].c1_06[0]" => @general.spouse_dependent,
      # "topmostSubform[0].Page1[0].c1_07[0]" => @general.spouse_itemizes,
      "topmostSubform[0].Page1[0].c1_08[0]" => @adapter.born_before_19560102?,
      "topmostSubform[0].Page1[0].c1_09[0]" => @adapter.blind?,
      "topmostSubform[0].Page1[0].c1_10[0]" => @adapter.spouse_born_before_19560102?,
      "topmostSubform[0].Page1[0].c1_11[0]" => @adapter.spouse_blind?,
      "topmostSubform[0].Page1[0].Dependents_ReadOrder[0].c1_12[0]" => @adapter.more_than_four_deps?,
    }
  end

  def draw_fields
    create_canvas
    draw_text_fields(text_fields, 6, 4)
    draw_text_fields(dependent_fields[:text], 1, 2)
    draw_button_fields(button_fields)
    draw_button_fields(dependent_fields[:button])
    draw_number_fields(money_fields)
  end

  def write_pdf
    strio = StringIO.new
    @doc.write(strio, validate: false, incremental: false, update_fields: true, optimize: false)
    strio.string
  end
end
