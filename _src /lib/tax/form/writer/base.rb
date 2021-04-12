require "hexapdf"
require "stringio"

module PiggyBank; end
module PiggyBank::Tax; end
module PiggyBank::Tax::Form; end
module PiggyBank::Tax::Form::Writer; end

# Subclass this to create a new form writer
# Define your form's initialize method (be
# sure to call `super`) and define a custom
# ::Writer#draw_fields method in your form
# writer class
class PiggyBank::Tax::Form::Writer::Base
  def initialize
    @format = PiggyBank::Formatter.new
    open_template @template
    extract_fields
  end

  def write_form
    draw_fields
    write_pdf
  end

  private

  def text_fields
    {}
  end

  def money_fields
    {}
  end

  def button_fields
    {}
  end

  def open_template(file)
    @doc = HexaPDF::Document.open file
  end

  def set_field_values(fields)
    fields.each do |name, value|
      if value
        field = @fields.find { |f| f.full_field_name == name }
        raise "Cannot find PDF field #{name}" if field.nil?
        field.field_value = value
      end
    end
  end

  def extract_fields
    form = @doc.acro_form
    @fields = []
    form.each_field { |f| @fields << f }
  end

  def write_pdf
    strio = StringIO.new
    @doc.write(strio, validate: false, incremental: false, update_fields: false, optimize: false)
    strio.string
  end

  def draw_fields
    set_field_values button_fields
    set_field_values text_fields
    set_field_values money_fields
  end
end
