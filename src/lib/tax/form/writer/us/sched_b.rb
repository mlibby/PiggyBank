require_relative "../base"

module PiggyBank::Tax::Form::Writer::US
  class ScheduleB < PiggyBank::Tax::Form::Writer::Base
    def initialize
      @template = "src/lib/tax/form/pdf/2020/us/f1040sb.pdf"
      super
      @adapter = PiggyBank::Tax::Form::Adapter::US::ScheduleB.new
    end

    private

    def text_fields
      {
        "topmostSubform[0].Page1[0].f1_1[0]" => @adapter.names,
        "topmostSubform[0].Page1[0].f1_2[0]" => @adapter.ssn,
        "topmostSubform[0].Page1[0].f1_3[0]" => @adapter.line_1_payer_1,
      }
    end

    def money_fields
      {
        "topmostSubform[0].Page1[0].f1_4[0]" => @format.as_currency(@adapter.line_1_amount_1),
        "topmostSubform[0].Page1[0].f1_31[0]" => @format.as_currency(@adapter.line_2),
        "topmostSubform[0].Page1[0].f1_33[0]" => @format.as_currency(@adapter.line_4),
      }
    end

    def button_fields
      {
      }
    end

    def draw_fields
      set_field_values button_fields
      set_field_values text_fields
      set_field_values money_fields
    end
  end
end
