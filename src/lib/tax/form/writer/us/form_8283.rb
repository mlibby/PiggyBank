require_relative "../base"

module PiggyBank::Tax::Form::Writer::US
  class Form8283 < PiggyBank::Tax::Form::Writer::Base
    def initialize
      @template = "src/lib/tax/form/pdf/2020/us/f8283.pdf"
      super
      deductions = PiggyBank::Tax::Data::Deduct.new
      noncash = deductions.noncash_donations[0..4]
      @adapter = PiggyBank::Tax::Form::Adapter::US::Form8283.new noncash
    end

    private

    def text_fields
      {
        "topmostSubform[0].Page1[0].f1_01[0]" => @adapter.names,
        "topmostSubform[0].Page1[0].f1_02[0]" => @adapter.ssn,
        "topmostSubform[0].Page1[0].Table_Line1_ColsA-C[0].Row1A[0].f1_03[0]" => @adapter.line_Aa,
        "topmostSubform[0].Page1[0].Table_Line1_ColsA-C[0].Row1A[0].f1_05[0]" => @adapter.line_Ac,
        "topmostSubform[0].Page1[0].Table_Line1_ColsD-I[0].Row1A[0].f1_18[0]" => @adapter.line_Ad,
        "topmostSubform[0].Page1[0].Table_Line1_ColsD-I[0].Row1A[0].f1_23[0]" => @adapter.line_Ai,
      }
    end

    def money_fields
      {
        "topmostSubform[0].Page1[0].Table_Line1_ColsD-I[0].Row1A[0].f1_22[0]" => @format.as_currency(@adapter.line_Ah),
        "topmostSubform[0].Page1[0].Table_Line1_ColsD-I[0].Row1B[0].f1_28[0]" => @format.as_currency(@adapter.line_Bh),
        "topmostSubform[0].Page1[0].Table_Line1_ColsD-I[0].Row1C[0].f1_34[0]" => @format.as_currency(@adapter.line_Ch),
        "topmostSubform[0].Page1[0].Table_Line1_ColsD-I[0].Row1D[0].f1_40[0]" => @format.as_currency(@adapter.line_Dh),
        "topmostSubform[0].Page1[0].Table_Line1_ColsD-I[0].Row1E[0].f1_46[0]" => @format.as_currency(@adapter.line_Eh),
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
