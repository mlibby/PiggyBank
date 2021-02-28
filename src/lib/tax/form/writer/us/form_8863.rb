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
      }
    end

    def money_fields
      {
 #  "form1[0].Page1[0].f1_03[0]" => @format.as_currency(@adapter.line_1),
               # "form1[0].Page1[0].f1_14[0]" => @format.as_currency(@adapter.line_9),
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
