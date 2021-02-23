require_relative "../base"

module PiggyBank::Tax::Form::Writer::US
  class ScheduleA < PiggyBank::Tax::Form::Writer::Base
    def initialize
      @template = "src/lib/tax/form/pdf/2020/us/f1040sa.pdf"
      super
      @adapter = PiggyBank::Tax::Form::Adapter::US::ScheduleA.new
    end

    private

    def text_fields
      {
        "topmostSubform[0].Page1[0].f1_1[0]" => @adapter.names,
        "topmostSubform[0].Page1[0].f1_2[0]" => @adapter.ssn,
      }
    end

    def money_fields
      {
        "topmostSubform[0].Page1[0].f1_7[0]" => @format.as_currency(@adapter.line_5a),
        "topmostSubform[0].Page1[0].f1_8[0]" => @format.as_currency(@adapter.line_5b),
        "topmostSubform[0].Page1[0].f1_9[0]" => @format.as_currency(@adapter.line_5c),
        "topmostSubform[0].Page1[0].f1_10[0]" => @format.as_currency(@adapter.line_5d),
        "topmostSubform[0].Page1[0].f1_11[0]" => @format.as_currency(@adapter.line_5e),
        "topmostSubform[0].Page1[0].f1_15[0]" => @format.as_currency(@adapter.line_7),
      }
    end

    def button_fields
      {
 #"topmostSubform[0].Page1[0].FilingStatus[0].c1_01[0]" => @general.filing_status == "single",
        }
    end

    def draw_fields
      set_field_values text_fields
      set_field_values money_fields
    end
  end
end
