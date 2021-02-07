require "hexapdf"
require "stringio"

module PiggyBank
  module TaxFormWriter
    class Form1040
      def write_form
        template = File.open("./src/lib/tax/form/pdf/2020/us/f1040.pdf", "rb")
        doc = HexaPDF::Document.new(io: template)
        p = doc.pages[0]
        widgets = p[:Annots]&.filter { |a| a[:Subtype] == :Widget }
        fields = widgets.map { |w| w.form_field }.filter { |f| f.concrete_field_type != :push_button }
        f = fields[6]
        f.field_name
        f.field_value
        f.field_value = "Jane D"
        fnames = fields.map { |f| [f.full_field_name, f.concrete_field_type] }
        strio = StringIO.new
        doc.write(strio, validate: false, incremental: false)
        return strio
      end
    end
  end
end
