require "hexapdf"
file_io = File.open("jqp.pdf", "rb")
doc = HexaPDF::Document.new(io: file_io)
p = doc.pages[0]
widgets = p[:Annots]&.filter { |a| a[:Subtype] == :Widget }
fields = widgets.map { |w| w.form_field }.filter { |f| f.concrete_field_type != :push_button }
f = fields[6]
f.field_name
f.field_value
f.field_value = "Jane D"
fnames = fields.map { |f| [f.full_field_name, f.concrete_field_type] }
doc.write("jdp.pdf", validate: false, incremental: false)
