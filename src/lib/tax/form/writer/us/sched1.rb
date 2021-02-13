require_relative "../base"

module PiggyBank; end
module PiggyBank::Tax; end
module PiggyBank::Tax::Form; end
module PiggyBank::Tax::Form::Writer; end
module PiggyBank::Tax::Form::Writer::US; end

class PiggyBank::Tax::Form::Writer::US::Schedule1 < PiggyBank::Tax::Form::Writer::Base
  def initialize
    @general = PiggyBank::Tax::Data::General.new
    @income = PiggyBank::Tax::Data::Income.new
  end

  def write_form
    @doc = get_doc
    @fields = get_fields
    update_fields
    write_pdf
  end

  private

  def get_doc
    HexaPDF::Document.open("src/lib/tax/form/pdf/2020/us/f1040s1.pdf")
  end

  def get_fields
    page1 = @doc.pages[0]
    widgets = page1[:Annots]&.filter { |a| a[:Subtype] == :Widget }
    form_fields = widgets.map { |w| w.form_field }
    form_fields.filter { |f| f.concrete_field_type != :push_button }
  end

  def text_fields
    {
            "form1[0].Page1[0].f1_01[0]" => @general.names,
            "form1[0].Page1[0].f1_02[0]" => @general.ssn,
          }
  end

  def money_fields
    {
 #"topmostSubform[0].Page1[0].Lines1-11_ReadOrder[0].f1_28[0]" => @income.total_wages,
      }
  end

  def button_fields
    {
 #"topmostSubform[0].Page1[0].FilingStatus[0].c1_01[0]" => @general.filing_status == "single",
      }
  end

  def update_fields
    canvas = @doc.pages[0].canvas(type: :overlay)
    canvas.font "Courier", size: 12, variant: :bold

    form = @doc.acro_form
    form_fields = []
    form.each_field { |f| form_fields << f }

    text_fields.each do |name, value|
      if value
        field = form_fields.find { |f| f.full_field_name == name }
        raise "Cannot find PDF field #{name}" if field.nil?
        x, y = field[:Rect]
        text = value.upcase
        canvas.text text, at: [x + 6, y + 4]
      end
    end

    button_fields.each do |name, value|
      if value
        field = form_fields.find { |f| f.full_field_name == name }
        raise "Cannot find PDF field #{name}" if field.nil?
        x, y = field[:Rect]
        canvas.text "X", at: [x + 0.5, y + 0.5]
      end
    end

    font = canvas.font.wrapped_font
    m_width = font.width :m
    font_scale = canvas.graphics_state.scaled_font_size
    m_scale = m_width * font_scale

    money_fields.each do |name, value|
      if value
        field = form_fields.find { |f| f.full_field_name == name }
        raise "Cannot find PDF field #{name}" if field.nil?
        a, y, x = field[:Rect]
        amount = format_currency value
        canvas.text amount, at: [x - amount.size * m_scale, y + 2]
      end
    end
  end

  def write_pdf
    strio = StringIO.new
    @doc.write(strio, validate: false, incremental: false, update_fields: true, optimize: false)
    strio.string
  end

  private

  def format_currency(value)
    segments = []
    value.round.digits.each_slice(3) { |s| segments << s.join }
    curr = segments.join(",").reverse
    "#{curr}."
  end

  def format_ssn(ssn)
    return if ssn.nil? || ssn == ""
    ssn.insert 3, " "
    ssn.insert 6, " "
  end
end
