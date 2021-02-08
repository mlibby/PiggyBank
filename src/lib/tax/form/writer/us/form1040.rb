require "hexapdf"
require "stringio"

module PiggyBank
  module TaxFormWriter
    class Form1040
      def initialize
        @general = PiggyBank::Tax::General.new
      end

      def write_form
        @doc = get_doc
        @fields = get_fields
        update_fields
        write_pdf
      end

      private

      def get_doc
        HexaPDF::Document.open("src/lib/tax/form/pdf/2020/us/f1040.pdf")
      end

      def get_fields
        page1 = @doc.pages[0]
        widgets = page1[:Annots]&.filter { |a| a[:Subtype] == :Widget }
        form_fields = widgets.map { |w| w.form_field }
        form_fields.filter { |f| f.concrete_field_type != :push_button }
      end

      def text_fields
        {
          "topmostSubform[0].Page1[0].f1_02[0]" => @general.first_name.upcase || "",
          "topmostSubform[0].Page1[0].f1_03[0]" => @general.last_name.upcase || "",
          "topmostSubform[0].Page1[0].YourSocial[0].f1_04[0]" => format_ssn(@general.ssn || ""),
          "topmostSubform[0].Page1[0].f1_05[0]" => @general.spouse_first_name.upcase || "",
          "topmostSubform[0].Page1[0].f1_06[0]" => @general.spouse_last_name.upcase || "",
          "topmostSubform[0].Page1[0].SpousesSocial[0].f1_07[0]" => format_ssn(@general.spouse_ssn || ""),
          "topmostSubform[0].Page1[0].Address[0].f1_08[0]" => @general.street.upcase || "",
          "topmostSubform[0].Page1[0].Address[0].f1_09[0]" => @general.apt_no.upcase || "",
          "topmostSubform[0].Page1[0].Address[0].f1_10[0]" => @general.city.upcase || "",
          "topmostSubform[0].Page1[0].Address[0].f1_11[0]" => @general.state.upcase || "",
          "topmostSubform[0].Page1[0].Address[0].f1_12[0]" => @general.zip.upcase || "",
          "topmostSubform[0].Page1[0].Address[0].f1_13[0]" => @general.country.upcase || "",
          "topmostSubform[0].Page1[0].Address[0].f1_14[0]" => @general.province.upcase || "",
          "topmostSubform[0].Page1[0].Address[0].f1_15[0]" => @general.post_code || "",
        }
      end

      def button_fields
        {
          "topmostSubform[0].Page1[0].FilingStatus[0].c1_01[0]" => @general.filing_status == "single",
          "topmostSubform[0].Page1[0].FilingStatus[0].c1_01[1]" => @general.filing_status == "married",
          "topmostSubform[0].Page1[0].FilingStatus[0].c1_01[2]" => @general.filing_status == "mfs",
          "topmostSubform[0].Page1[0].FilingStatus[0].c1_01[3]" => @general.filing_status == "hoh",
          "topmostSubform[0].Page1[0].FilingStatus[0].c1_01[4]" => @general.filing_status == "qw",
          "topmostSubform[0].Page1[0].c1_02[0]" => @general.campaign,
          "topmostSubform[0].Page1[0].c1_03[0]" => @general.spouse_campaign,
          "topmostSubform[0].Page1[0].c1_04[0]" => @general.virtual,
          "topmostSubform[0].Page1[0].c1_04[1]" => !@general.virtual,
          # "topmostSubform[0].Page1[0].c1_05[0]" => @general.dependent,
          # "topmostSubform[0].Page1[0].c1_06[0]" => @general.spouse_dependent,
          # "topmostSubform[0].Page1[0].c1_06[0]" => @general.spouse_itemizes,
          "topmostSubform[0].Page1[0].c1_07[0]" => @general.birthday < "1956-01-02",
          "topmostSubform[0].Page1[0].c1_08[0]" => @general.blind,
          "topmostSubform[0].Page1[0].c1_09[0]" => @general.spouse_birthday < "1956-01-02",
          "topmostSubform[0].Page1[0].c1_10[0]" => @general.spouse_blind,
          # "topmostSubform[0].Page1[0].c1_11[0]" => @general.dependents.size > 4,
        }
      end

      def update_fields
        canvas = @doc.pages[0].canvas(type: :overlay)
        canvas.font "Courier", variant: :bold, size: 12

        form = @doc.acro_form
        form_fields = []
        form.each_field { |f| form_fields << f }

        text_fields.each do |name, value|
          field = form_fields.find { |f| f.full_field_name == name }
          raise "Cannot find PDF field #{name}" if field.nil?
          x, y = field[:Rect]
          canvas.text value, at: [x + 6, y + 4]
        end

        button_fields.each do |name, value|
          if value
            field = form_fields.find { |f| f.full_field_name == name }
            x, y = field[:Rect]
            canvas.text "X", at: [x + 0.5, y + 0.5]
          end
        end
      end

      def write_pdf
        strio = StringIO.new
        @doc.write(strio, validate: false, incremental: false, update_fields: true, optimize: false)
        strio.string
      end

      private

      def format_ssn(ssn)
        return if ssn == ""
        ssn.insert 3, " "
        ssn.insert 6, " "
      end
    end
  end
end
