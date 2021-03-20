require_relative "../base"

module PiggyBank::Tax::Form::Writer::US
  class Form6198 < PiggyBank::Tax::Form::Writer::Base
    def initialize
      @template = "src/lib/tax/form/pdf/2020/us/f6198.pdf"
      super
      us_schede = PiggyBank::Tax::Form::Adapter::US::ScheduleE.instance
      @adapter = PiggyBank::Tax::Form::Adapter::US::Form6198.instance
      @adapter.us_schede = us_schede
      us_schede.us_6198 = @adapter
    end

    private

    def text_fields
      {
        "topmostSubform[0].Page1[0].f1_1[0]" => @adapter.names,
        "topmostSubform[0].Page1[0].f1_2[0]" => @adapter.ssn,
        "topmostSubform[0].Page1[0].f1_3[0]" => @adapter.description,
      }
    end

    def money_fields
      {
        "topmostSubform[0].Page1[0].f1_4[0]" => @format.as_currency(@adapter.line_1),
        "topmostSubform[0].Page1[0].f1_10[0]" => @format.as_currency(@adapter.line_5, true),
        "topmostSubform[0].Page1[0].f1_17[0]" => @format.as_currency(@adapter.line_11, true),
        "topmostSubform[0].Page1[0].f1_19[0]" => @format.as_currency(@adapter.line_13, true),
        "topmostSubform[0].Page1[0].f1_20[0]" => @format.as_currency(@adapter.line_15, true),
        "topmostSubform[0].Page1[0].f1_23[0]" => @format.as_currency(@adapter.line_17, true),
        "topmostSubform[0].Page1[0].f1_25[0]" => @format.as_currency(@adapter.line_19a, true),
        "topmostSubform[0].Page1[0].f1_26[0]" => @format.as_currency(@adapter.line_19b, true),
        "topmostSubform[0].Page1[0].f1_27[0]" => @format.as_currency(@adapter.line_20, true),
        "topmostSubform[0].Page1[0].f1_28[0]" => @format.as_currency(@adapter.line_21, true),
      }
    end

    def button_fields
      {
        "topmostSubform[0].Page1[0].c1_1[0]" => @adapter.line_15a,
      }
    end

    def draw_fields
      set_field_values text_fields
      set_field_values money_fields
    end
  end
end
