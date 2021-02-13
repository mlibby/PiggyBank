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
  
  def open_template(file)
    @doc = HexaPDF::Document.open file
  end

  def extract_fields
    form = @doc.acro_form
    @fields = []
    form.each_field { |f| @fields << f }
  end

  def create_canvas
    @canvas = @doc.pages[0].canvas(type: :overlay)
    @canvas.font "Courier", size: 12, variant: :bold
    font = @canvas.font.wrapped_font
    m_width = font.width :m
    font_scale = @canvas.graphics_state.scaled_font_size
    @m_scale = m_width * font_scale
  end

  def draw_text_fields(fields, x_offset, y_offset)
    fields.each do |name, value|
      if value
        field = @fields.find { |f| f.full_field_name == name }
        raise "Cannot find PDF field #{name}" if field.nil?
        x, y = field[:Rect]
        text = value.upcase
        @canvas.text text, at: [x + x_offset, y + y_offset]
      end
    end
  end

  def draw_number_fields(fields) 
    fields.each do |name, value|
      if value
        field = @fields.find { |f| f.full_field_name == name }
        raise "Cannot find PDF field #{name}" if field.nil?
        a, y, x = field[:Rect]
        @canvas.text value, at: [x - value.size * @m_scale, y + 2]
      end
    end
  end

  def draw_button_fields(fields, char = "X")
    fields.each do |name, value|
      if value
        field = @fields.find { |f| f.full_field_name == name }
        raise "Cannot find PDF field #{name}" if field.nil?
        x, y = field[:Rect]
        @canvas.text "X", at: [x + 0.5, y + 0.5]
      end
    end
  end 

  def write_pdf
    strio = StringIO.new
    @doc.write(strio, validate: false, incremental: false, update_fields: true, optimize: false)
    strio.string
  end
end