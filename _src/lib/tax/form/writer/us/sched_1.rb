require_relative "../base"

module PiggyBank::Tax::Form::Writer::US
  class Schedule1 < PiggyBank::Tax::Form::Writer::Base
    def initialize
      @template = "src/lib/tax/form/pdf/2020/us/f1040s1.pdf"
      super
      @adapter = PiggyBank::Tax::Form::Adapter::US::Schedule1.new
    end

    private

    def text_fields
      {
        "form1[0].Page1[0].f1_01[0]" => @adapter.names,
        "form1[0].Page1[0].f1_02[0]" => @adapter.ssn,
      }
    end

    def money_fields
      {
        "form1[0].Page1[0].f1_03[0]" => @format.as_currency(@adapter.line_1),
        "form1[0].Page1[0].f1_08[0]" => @format.as_currency(@adapter.line_5),
        "form1[0].Page1[0].f1_14[0]" => @format.as_currency(@adapter.line_9),
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
