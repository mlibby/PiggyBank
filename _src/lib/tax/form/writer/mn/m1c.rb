require_relative "../base"

module PiggyBank::Tax::Form::Writer::MN
  class M1C < PiggyBank::Tax::Form::Writer::Base
    def initialize
      @template = "src/lib/tax/form/pdf/2020/mn/m1c_20.pdf"
      super
      @adapter = PiggyBank::Tax::Form::Adapter::MN::M1C.instance
    end

    private

    def text_fields
      {
        "YourFirstNameandInitial" => @adapter.first_name,
        "yourlastname" => @adapter.last_name,
        "YourSocialSecurityNumber" => @adapter.ssn,
      }
    end

    def money_fields
      {
        "m1cline1" => @format.as_currency(@adapter.line_1),
        "m1cline7" => @format.as_currency(@adapter.line_7),
        "m1cline17" => @format.as_currency(@adapter.line_17),
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
