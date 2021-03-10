require_relative "../base"

module PiggyBank::Tax::Form::Writer::US
  class ScheduleB < PiggyBank::Tax::Form::Writer::Base
    def initialize
      @template = "src/lib/tax/form/pdf/2020/us/f1040sb.pdf"
      super
      @adapter = PiggyBank::Tax::Form::Adapter::US::ScheduleB.new
    end

    private

    def text_fields
      {
        "topmostSubform[0].Page1[0].f1_1[0]" => @adapter.names,
        "topmostSubform[0].Page1[0].f1_2[0]" => @adapter.ssn,
        # "topmostSubform[0].Page1[0].Line1[0].Table1a[0].RowA[0].f1_3[0]" => @adapter.line_1a_A,
        # "topmostSubform[0].Page1[0].Line1[0].Table1b[0].RowA[0].f1_6[0]" => @adapter.line_1b_type_A,
        # "topmostSubform[0].Page1[0].Table_Line2[0].RowA[0].f1_9[0]" => @adapter.line_1b_rental_days_A,
        # "topmostSubform[0].Page1[0].Table_Line2[0].RowA[0].f1_10[0]" => @adapter.line_1b_personal_days_A,
      }
    end

    def money_fields
      {
        # "topmostSubform[0].Page1[0].Table_Income[0].Income[0].Line3[0].f1_16[0]" => @format.as_currency(@adapter.line_3A),
        # "topmostSubform[0].Page1[0].Table_Income[0].Income[0].Line4[0].f1_19[0]" => @format.as_currency(@adapter.line_4A),
        # "topmostSubform[0].Page1[0].Table_Expenses[0].Line11[0].f1_40[0]" => @format.as_currency(@adapter.line_11A),
        # "topmostSubform[0].Page1[0].Table_Expenses[0].Line16[0].f1_55[0]" => @format.as_currency(@adapter.line_16A),

        # "topmostSubform[0].Page1[0].Table_Expenses[0].Line20[0].f1_68[0]" => @format.as_currency(@adapter.line_20A),
        # "topmostSubform[0].Page1[0].Table_Expenses[0].Line21[0].f1_71[0]" => @format.as_currency(@adapter.line_21A),

        # "topmostSubform[0].Page1[0].f1_77[0]" => @format.as_currency(@adapter.line_23a),
        # "topmostSubform[0].Page1[0].f1_81[0]" => @format.as_currency(@adapter.line_23e),
        # "topmostSubform[0].Page1[0].f1_82[0]" => @format.as_currency(@adapter.line_24),
        # "topmostSubform[0].Page1[0].f1_83[0]" => @format.as_currency(@adapter.line_25),
        # "topmostSubform[0].Page1[0].f1_84[0]" => @format.as_currency(@adapter.line_26),
      }
    end

    def button_fields
      {
        # "topmostSubform[0].Page1[0].Table_Line2[0].RowA[0].c1_3[0]" => @adapter.line_1b_qjv_A,
      }
    end

    def draw_fields
      set_field_values button_fields
      set_field_values text_fields
      set_field_values money_fields
    end
  end
end
