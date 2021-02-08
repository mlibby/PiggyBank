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
        @doc.acro_form.need_appearances!
        @fields = get_fields

        canvas = @doc.pages[0].canvas(type: :overlay)
        canvas.font "Courier", variant: :bold, size: 12
        canvas.text "123-45-6789", at: [475, 671]

        update_fields
        write_pdf
      end

      private

      def get_doc
        template = File.open("./src/lib/tax/form/pdf/2020/us/f1040.pdf", "rb")
        HexaPDF::Document.new(io: template)
      end

      def get_fields
        page1 = @doc.pages[0]
        widgets = page1[:Annots]&.filter { |a| a[:Subtype] == :Widget }
        form_fields = widgets.map { |w| w.form_field }
        form_fields.filter { |f| f.concrete_field_type != :push_button }
      end

      def update_fields
        @fields[6].field_value = @general.first_name
        @fields[6][:DA] = "Courier-Bold 10.00"
        @fields[7].field_value = @general.last_name
        @fields[7][:DA] = "Courier-Bold 10.00"
        @fields[9].field_value = @general.spouse_first_name
        @fields[10].field_value = @general.spouse_last_name

        @fields[12].field_value = @general.street
        @fields[13].field_value = @general.apt_no
        @fields[14].field_value = @general.city
        @fields[15].field_value = @general.state
        @fields[16].field_value = @general.zip
        @fields[17].field_value = @general.country
        @fields[18].field_value = @general.province
        @fields[19].field_value = @general.post_code
      end

      def write_pdf
        strio = StringIO.new
        @doc.write(strio, validate: false, incremental: false, update_fields: true, optimize: false)
        strio.string
      end
    end
  end
end
