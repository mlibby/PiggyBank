require_relative "../base"

module PiggyBank::Tax::Form::Writer::MN
  class M1529 < PiggyBank::Tax::Form::Writer::Base
    def initialize
      @template = "src/lib/tax/form/pdf/2020/mn/m1529_20.pdf"
      super
      @adapter = PiggyBank::Tax::Form::Adapter::MN::M1529.new
    end

    private

    def text_fields
      {
        "yourfirstname" => @adapter.first_name,
        "yourlastname" => @adapter.last_name,
        "socialsecuritynumber" => @adapter.ssn,
        "Trustee" => @adapter.line_1_fi_1,
        "Account Number" => @adapter.line_1_account_1,
        "Trustee_2" => @adapter.line_1_fi_2,
        "Account Number_2" => @adapter.line_1_account_2,
      }
    end

    def money_fields
      {
        "Amount" => @format.as_currency(@adapter.line_1_amount_1),
        "Amount_2" => @format.as_currency(@adapter.line_1_amount_2),
        "M1529line1" => @format.as_currency(@adapter.line_1),
        "M1529line3" => @format.as_currency(@adapter.line_3),
        "M1529line5" => @format.as_currency(@adapter.line_5),
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
