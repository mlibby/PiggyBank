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
        "socialsecuritynumber" => @adapter.ssn,
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
      create_canvas
      draw_text_fields(text_fields, 3, 6)
      draw_number_fields(money_fields)
    end
  end
end
