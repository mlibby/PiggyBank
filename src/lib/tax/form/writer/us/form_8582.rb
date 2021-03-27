require_relative "../base"

module PiggyBank::Tax::Form::Writer::US
  class Form8582 < PiggyBank::Tax::Form::Writer::Base
    def initialize
      @template = "src/lib/tax/form/pdf/2020/us/f8582.pdf"
      super
      @adapter = PiggyBank::Tax::Form::Adapter::US::Form8582.instance
    end

    private

    def text_fields
      {
        "topmostSubform[0].Page1[0].f1_01[0]" => @adapter.names,
        "topmostSubform[0].Page1[0].f1_02[0]" => @adapter.ssn,
        "topmostSubform[0].Page2[0].Table_Worksheet3[0].Row1[0].f2_55[0]" => @adapter.worksheet_3_line_1_name,
      }
    end

    def money_fields
      {
        "topmostSubform[0].Page2[0].Table_Worksheet3[0].Row1[0].f2_56[0]" => @format.as_currency(@adapter.worksheet_3_line_1a),
        "topmostSubform[0].Page2[0].Table_Worksheet3[0].Row1[0].f2_57[0]" => @format.as_currency(@adapter.worksheet_3_line_1b),
        "topmostSubform[0].Page2[0].Table_Worksheet3[0].Row1[0].f2_59[0]" => @format.as_currency(@adapter.worksheet_3_line_1d),
        "topmostSubform[0].Page2[0].Table_Worksheet3[0].Row1[0].f2_60[0]" => @format.as_currency(@adapter.worksheet_3_line_1e),
        "topmostSubform[0].Page2[0].Table_Worksheet3[0].Total[0].f2_85[0]" => @format.as_currency(@adapter.worksheet_3_total_a),
        "topmostSubform[0].Page2[0].Table_Worksheet3[0].Total[0].f2_86[0]" => @format.as_currency(@adapter.worksheet_3_total_b),
        "topmostSubform[0].Page1[0].f1_10[0]" => @format.as_currency(@adapter.line_3a),
        "topmostSubform[0].Page1[0].f1_11[0]" => @format.as_currency(@adapter.line_3b),
        "topmostSubform[0].Page1[0].f1_13[0]" => @format.as_currency(@adapter.line_3d),
        "topmostSubform[0].Page1[0].f1_14[0]" => @format.as_currency(@adapter.line_4),
        "topmostSubform[0].Page1[0].f1_25[0]" => @format.as_currency(@adapter.line_15, true),
        "topmostSubform[0].Page1[0].f1_26[0]" => @format.as_currency(@adapter.line_16, true),
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
