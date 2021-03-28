require_relative "../base"

module PiggyBank::Tax::Form::Writer::MN
  class M1SA < PiggyBank::Tax::Form::Writer::Base
    def initialize
      @template = "src/lib/tax/form/pdf/2020/mn/m1sa_20.pdf"
      super
      @adapter = PiggyBank::Tax::Form::Adapter::MN::M1SA.instance
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
        "M1SAline2" => @format.as_currency(@adapter.line_2),
        "M1SAline3" => @format.as_currency(@adapter.line_3),
        "M1SAline4" => @format.as_currency(@adapter.line_4, true),
        "M1SAline5" => @format.as_currency(@adapter.line_5),
        "M1SAline6" => @format.as_currency(@adapter.line_6),
        "M1SAline7" => @format.as_currency(@adapter.line_7),
        "M1SAline8" => @format.as_currency(@adapter.line_8),
        "M1SAline10" => @format.as_currency(@adapter.line_10),
        "M1SAline11" => @format.as_currency(@adapter.line_11),
        "M1SAline12" => @format.as_currency(@adapter.line_12),
        "M1SAline13" => @format.as_currency(@adapter.line_13),
        "M1SAline14" => @format.as_currency(@adapter.line_14),
        "M1SAline15" => @format.as_currency(@adapter.line_15),
        "M1SAline16" => @format.as_currency(@adapter.line_16),
        "M1SAline17" => @format.as_currency(@adapter.line_17),
        "M1SAline18" => @format.as_currency(@adapter.line_18),
        "M1SAline25" => @format.as_currency(@adapter.line_25),
        "M1SAline27" => @format.as_currency(@adapter.line_27),
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
