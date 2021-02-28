require_relative "../base"

module PiggyBank::Tax::Form::Writer::US
  class Form8283 < PiggyBank::Tax::Form::Writer::Base
    def initialize(form_number)
      @form_number = form_number.to_i
      @template = "src/lib/tax/form/pdf/2020/us/f8283.pdf"
      @format = PiggyBank::Formatter.new
      @deduct = PiggyBank::Tax::Data::Deduct.new
      super()
    end

    def write_form
      noncash = @deduct.noncash_donations.each_slice(5).to_a[@form_number - 1]
      @adapter = PiggyBank::Tax::Form::Adapter::US::Form8283.new noncash
      draw_fields
      write_pdf
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

        "topmostSubform[0].Page1[0].Table_Line1_ColsA-C[0].Row1B[0].f1_06[0]" => @adapter.line_Ba,
        "topmostSubform[0].Page1[0].Table_Line1_ColsA-C[0].Row1B[0].f1_08[0]" => @adapter.line_Bc,
        "topmostSubform[0].Page1[0].Table_Line1_ColsD-I[0].Row1B[0].f1_24[0]" => @adapter.line_Bd,
        "topmostSubform[0].Page1[0].Table_Line1_ColsD-I[0].Row1B[0].f1_29[0]" => @adapter.line_Bi,

        "topmostSubform[0].Page1[0].Table_Line1_ColsA-C[0].Row1C[0].f1_09[0]" => @adapter.line_Ca,
        "topmostSubform[0].Page1[0].Table_Line1_ColsA-C[0].Row1C[0].f1_11[0]" => @adapter.line_Cc,
        "topmostSubform[0].Page1[0].Table_Line1_ColsD-I[0].Row1C[0].f1_30[0]" => @adapter.line_Cd,
        "topmostSubform[0].Page1[0].Table_Line1_ColsD-I[0].Row1C[0].f1_35[0]" => @adapter.line_Ci,

        "topmostSubform[0].Page1[0].Table_Line1_ColsA-C[0].Row1D[0].f1_12[0]" => @adapter.line_Da,
        "topmostSubform[0].Page1[0].Table_Line1_ColsA-C[0].Row1D[0].f1_14[0]" => @adapter.line_Dc,
        "topmostSubform[0].Page1[0].Table_Line1_ColsD-I[0].Row1D[0].f1_36[0]" => @adapter.line_Dd,
        "topmostSubform[0].Page1[0].Table_Line1_ColsD-I[0].Row1D[0].f1_41[0]" => @adapter.line_Di,

        "topmostSubform[0].Page1[0].Table_Line1_ColsA-C[0].Row1E[0].f1_15[0]" => @adapter.line_Ea,
        "topmostSubform[0].Page1[0].Table_Line1_ColsA-C[0].Row1E[0].f1_17[0]" => @adapter.line_Ec,
        "topmostSubform[0].Page1[0].Table_Line1_ColsD-I[0].Row1E[0].f1_42[0]" => @adapter.line_Ed,
        "topmostSubform[0].Page1[0].Table_Line1_ColsD-I[0].Row1E[0].f1_47[0]" => @adapter.line_Ei,
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
