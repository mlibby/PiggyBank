require_relative "../base"

module PiggyBank::Tax::Form::Writer::MN
  class M1M < PiggyBank::Tax::Form::Writer::Base
    def initialize
      @template = "src/lib/tax/form/pdf/2020/mn/m1m_20.pdf"
      super
      @adapter = PiggyBank::Tax::Form::Adapter::MN::M1M.new
    end

    private

    def text_fields
      {
        "YourFirstNameandInitial" => @adapter.first_name,
        "LastName" => @adapter.last_name,
        "YourSocialSecurityNumber" => @adapter.ssn,
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
