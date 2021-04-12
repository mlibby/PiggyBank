require_relative "../base"

module PiggyBank::Tax::Form::Writer::MN
  class M1W < PiggyBank::Tax::Form::Writer::Base
    def initialize
      @template = "src/lib/tax/form/pdf/2020/mn/m1w_20.pdf"
      super
      @adapter = PiggyBank::Tax::Form::Adapter::MN::M1W.instance
    end

    private

    def text_fields
      {
        "YourFirstNameandInitial" => @adapter.first_name,
        "LastName" => @adapter.last_name,
        "YourSocialSecurityNumber" => @adapter.ssn,
        "IfaJointReturnSpousesFirstNameandInitial" => @adapter.spouse_first_name,
        "SpousesLastName" => @adapter.spouse_last_name,
        "SpousesSocialSecurityNumber" => @adapter.spouse_ssn,
        "M1Wline1a1" => @adapter.line_1a1,
        "M1Wline1c1" => @adapter.line_1c1,
        "M1Wline1a2" => @adapter.line_1a2,
        "M1Wline1c2" => @adapter.line_1c2,
        "M1Wline1a3" => @adapter.line_1a3,
        "M1Wline1c3" => @adapter.line_1c3,
      }
    end

    def money_fields
      {
        "M1Wline1d1" => @format.as_currency(@adapter.line_1d1),
        "M1Wline1e1" => @format.as_currency(@adapter.line_1e1),
        "M1Wline1d2" => @format.as_currency(@adapter.line_1d2),
        "M1Wline1e2" => @format.as_currency(@adapter.line_1e2),
        "M1Wline1d3" => @format.as_currency(@adapter.line_1d3),
        "M1Wline1e3" => @format.as_currency(@adapter.line_1e3),
        "M1Wline1total" => @format.as_currency(@adapter.line_1),
        "M1Wline4" => @format.as_currency(@adapter.line_4),
      }
    end

    def button_fields
      {
        "M1Wline1b1" => @adapter.line_1b1,
        "M1Wline1b2" => @adapter.line_1b2,
        "M1Wline1b3" => @adapter.line_1b3,
      }
    end

    def draw_fields
      set_field_values text_fields
      set_field_values money_fields
    end
  end
end
