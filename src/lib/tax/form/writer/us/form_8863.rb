require_relative "../base"

module PiggyBank::Tax::Form::Writer::US
  class Form8863 < PiggyBank::Tax::Form::Writer::Base
    def initialize
      @template = "src/lib/tax/form/pdf/2020/us/f8863.pdf"
      super
      @adapter = PiggyBank::Tax::Form::Adapter::US::Form8863.new
    end

    private

    def text_fields
      {
        "topmostSubform[0].Page1[0].f1_1[0]" => @adapter.names,
        "topmostSubform[0].Page1[0].SocialSecurity[0].f1_2[0]" => @adapter.ssn_part_one,
        "topmostSubform[0].Page1[0].SocialSecurity[0].f1_3[0]" => @adapter.ssn_part_two,
        "topmostSubform[0].Page1[0].SocialSecurity[0].f1_4[0]" => @adapter.ssn_part_three,

        "topmostSubform[0].Page1[0].f1_22[0]" => @adapter.line_17_integer,
        "topmostSubform[0].Page1[0].f1_23[0]" => @adapter.line_17_fractional,

        "topmostSubform[0].Page2[0].NameShown[0]" => @adapter.names,
        "topmostSubform[0].Page2[0].SSN[0].f2_1[0]" => @adapter.ssn_part_one,
        "topmostSubform[0].Page2[0].SSN[0].f2_2[0]" => @adapter.ssn_part_two,
        "topmostSubform[0].Page2[0].SSN[0].f2_3[0]" => @adapter.ssn_part_three,

        "topmostSubform[0].Page2[0].StudentName[0]" => @adapter.line_20,
        "topmostSubform[0].Page2[0].StudentSSN[0].f2_4[0]" => @adapter.line_21a,
        "topmostSubform[0].Page2[0].StudentSSN[0].f2_5[0]" => @adapter.line_21b,
        "topmostSubform[0].Page2[0].StudentSSN[0].f2_6[0]" => @adapter.line_21c,
        "topmostSubform[0].Page2[0].Line22a[0].f2_7[0]" => @adapter.line_22a,
        "topmostSubform[0].Page2[0].Line22a[0].f2_8[0]" => @adapter.line_22a1,

        "topmostSubform[0].Page2[0].Line22a[0].f2_9[0]" => @adapter.institution_ein[0],
        "topmostSubform[0].Page2[0].Line22a[0].f2_10[0]" => @adapter.institution_ein[1],
        "topmostSubform[0].Page2[0].Line22a[0].f2_11[0]" => @adapter.institution_ein[3],
        "topmostSubform[0].Page2[0].Line22a[0].f2_12[0]" => @adapter.institution_ein[4],
        "topmostSubform[0].Page2[0].Line22a[0].f2_13[0]" => @adapter.institution_ein[5],
        "topmostSubform[0].Page2[0].Line22a[0].f2_14[0]" => @adapter.institution_ein[6],
        "topmostSubform[0].Page2[0].Line22a[0].f2_15[0]" => @adapter.institution_ein[7],
        "topmostSubform[0].Page2[0].Line22a[0].f2_16[0]" => @adapter.institution_ein[8],
        "topmostSubform[0].Page2[0].Line22a[0].f2_17[0]" => @adapter.institution_ein[9],
      }
    end

    def money_fields
      {
        "topmostSubform[0].Page1[0].f1_5[0]" => @format.as_currency(@adapter.line_1, true),
        "topmostSubform[0].Page1[0].f1_12[0]" => @format.as_currency(@adapter.line_7, true),
        "topmostSubform[0].Page1[0].f1_13[0]" => @format.as_currency(@adapter.line_8, true),
        "topmostSubform[0].Page1[0].f1_14[0]" => @format.as_currency(@adapter.line_9, true),
        "topmostSubform[0].Page2[0].f2_33[0]" => @format.as_currency(@adapter.line_31),
        "topmostSubform[0].Page1[0].f1_15[0]" => @format.as_currency(@adapter.line_10),
        "topmostSubform[0].Page1[0].f1_16[0]" => @format.as_currency(@adapter.line_11),
        "topmostSubform[0].Page1[0].f1_17[0]" => @format.as_currency(@adapter.line_12),
        "topmostSubform[0].Page1[0].f1_18[0]" => @format.as_currency(@adapter.line_13),
        "topmostSubform[0].Page1[0].f1_19[0]" => @format.as_currency(@adapter.line_14),
        "topmostSubform[0].Page1[0].f1_20[0]" => @format.as_currency(@adapter.line_15),
        "topmostSubform[0].Page1[0].f1_21[0]" => @format.as_currency(@adapter.line_16),
        "topmostSubform[0].Page1[0].f1_24[0]" => @format.as_currency(@adapter.line_18, true),
        "topmostSubform[0].Page1[0].f1_25[0]" => @format.as_currency(@adapter.line_19, true),
      }
    end

    def button_fields
      {
        "topmostSubform[0].Page2[0].Line22a[0].c2_1[0]" => @adapter.line_22a2 == true,
        "topmostSubform[0].Page2[0].Line22a[0].c2_1[1]" => @adapter.line_22a2 == false,
        "topmostSubform[0].Page2[0].Line22a[0].c2_2[0]" => @adapter.line_22a3 == true,
        "topmostSubform[0].Page2[0].Line22a[0].c2_2[1]" => @adapter.line_22a3 == false,
        "topmostSubform[0].Page2[0].c2_5[0]" => @adapter.line_23 == true,
        "topmostSubform[0].Page2[0].c2_5[1]" => @adapter.line_23 == false,
        "topmostSubform[0].Page2[0].c2_6[0]" => @adapter.line_24 == true,
        "topmostSubform[0].Page2[0].c2_6[1]" => @adapter.line_24 == false,
        "topmostSubform[0].Page2[0].c2_7[0]" => @adapter.line_25 == true,
        "topmostSubform[0].Page2[0].c2_7[1]" => @adapter.line_25 == false,
      }
    end

    def draw_fields
      set_field_values text_fields
      set_field_values money_fields
      set_field_values button_fields
    end
  end
end
