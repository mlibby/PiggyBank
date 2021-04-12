require_relative "../base"

module PiggyBank::Tax::Form::Writer::US
  class Form8889 < PiggyBank::Tax::Form::Writer::Base
    def initialize
      @template = "src/lib/tax/form/pdf/2020/us/f8889.pdf"
      super
      @adapter = PiggyBank::Tax::Form::Adapter::US::Form8889.new
    end

    private

    def text_fields
      {
        "topmostSubform[0].Page1[0].f1_01[0]" => @adapter.names,
        "topmostSubform[0].Page1[0].f1_02[0]" => @adapter.ssn,
      }
    end

    def money_fields
      {
        "topmostSubform[0].Page1[0].f1_03[0]" => @format.as_currency(@adapter.line_2, true),
        "topmostSubform[0].Page1[0].f1_04[0]" => @format.as_currency(@adapter.line_3, true),
        "topmostSubform[0].Page1[0].f1_05[0]" => @format.as_currency(@adapter.line_4, true),
        "topmostSubform[0].Page1[0].f1_06[0]" => @format.as_currency(@adapter.line_5, true),
        "topmostSubform[0].Page1[0].f1_07[0]" => @format.as_currency(@adapter.line_6, true),
        "topmostSubform[0].Page1[0].f1_08[0]" => @format.as_currency(@adapter.line_7, true),
        "topmostSubform[0].Page1[0].f1_09[0]" => @format.as_currency(@adapter.line_8, true),
        "topmostSubform[0].Page1[0].f1_10[0]" => @format.as_currency(@adapter.line_9, true),
        "topmostSubform[0].Page1[0].f1_11[0]" => @format.as_currency(@adapter.line_10, true),
        "topmostSubform[0].Page1[0].f1_12[0]" => @format.as_currency(@adapter.line_11, true),
        "topmostSubform[0].Page1[0].f1_13[0]" => @format.as_currency(@adapter.line_12, true),
        "topmostSubform[0].Page1[0].f1_14[0]" => @format.as_currency(@adapter.line_13, true),
        "topmostSubform[0].Page1[0].f1_15[0]" => @format.as_currency(@adapter.line_14a, true),
        "topmostSubform[0].Page1[0].f1_16[0]" => @format.as_currency(@adapter.line_14b, true),
        "topmostSubform[0].Page1[0].f1_17[0]" => @format.as_currency(@adapter.line_14c, true),
        "topmostSubform[0].Page1[0].f1_18[0]" => @format.as_currency(@adapter.line_15, true),
        "topmostSubform[0].Page1[0].f1_19[0]" => @format.as_currency(@adapter.line_16, true),
      }
    end

    def button_fields
      {
        "topmostSubform[0].Page1[0].c1_1[0]" => @adapter.covered_by_hdhp == "self",
        "topmostSubform[0].Page1[0].c1_1[1]" => @adapter.covered_by_hdhp == "family",
      }
    end

    def draw_fields
      set_field_values text_fields
      set_field_values money_fields
    end
  end
end
