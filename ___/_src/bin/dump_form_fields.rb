require "hexapdf"

pdf = HexaPDF::Document.open(ARGV[0])
fields = []
pdf.acro_form.each_field do |field|
  fields << field.full_field_name
end
f = File.open(ARGV[1], "w")
f.puts fields.join "\n"
