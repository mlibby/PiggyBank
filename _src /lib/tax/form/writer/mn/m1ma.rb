require_relative "../base"

module PiggyBank::Tax::Form::Writer::MN
  class M1MA < PiggyBank::Tax::Form::Writer::Base
    def initialize
      @template = "src/lib/tax/form/pdf/2020/mn/m1ma_20.pdf"
      super
      @adapter = PiggyBank::Tax::Form::Adapter::MN::M1MA.instance
    end

    private

    def text_fields
      {
        "YourFirstNameandInitial" => @adapter.first_name,
        "LastName" => @adapter.last_name,
        "SocialSecurityNumber" => @adapter.ssn,
        "SpousesFirstNameandInitial" => @adapter.spouse_first_name,
        "LastName2" => @adapter.spouse_last_name,
        "SocialSecurityNumber2" => @adapter.spouse_ssn,
      }
    end

    def money_fields
      {
        "M1MAline1a" => @format.as_currency(@adapter.line_1a),
        "M1MAline1b" => @format.as_currency(@adapter.line_1b),
        "M1MAline5a" => @format.as_currency(@adapter.line_5a),
        "M1MAline5b" => @format.as_currency(@adapter.line_5b),
        "M1MAline6b" => @format.as_currency(@adapter.line_6),
        "M1MAline7" => @format.as_currency(@adapter.line_7),
        "M1MAline8" => @format.as_currency(@adapter.line_8),
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
