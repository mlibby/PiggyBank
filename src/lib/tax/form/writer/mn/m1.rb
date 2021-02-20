require_relative "../base"

module PiggyBank::Tax::Form::Writer::MN
  class M1 < PiggyBank::Tax::Form::Writer::Base
    def initialize
      @template = "src/lib/tax/form/pdf/2020/mn/m1_20.pdf"
      super
      @adapter = PiggyBank::Tax::Form::Adapter::MN::M1.new
    end

    private

    def text_fields
      {
        "yourfirstnameandinitial" => @adapter.first_name,
        "LastName" => @adapter.last_name,
        "YourSocialSecurityNumber" => @adapter.ssn,
        "YourDateofBirth" => @adapter.birthday,
        "SpousesFirstNameandInitial" => @adapter.spouse_first_name,
        "Spouseslastname" => @adapter.spouse_last_name,
        "SpousesSocialSecurityNumber" => @adapter.spouse_ssn,
        "spousesdateofbirth" => @adapter.spouse_birthday,
        "CurrentHomeAddress" => @adapter.address,
        "city" => @adapter.city,
        "state" => @adapter.state,
        "zipcode" => @adapter.zip,
        "m1line1" => "12,345."
      }
    end

    def money_fields
      {
 #  "form1[0].Page1[0].f1_03[0]" => @format.as_currency(@adapter.line_1),
               # "form1[0].Page1[0].f1_14[0]" => @format.as_currency(@adapter.line_9),
        }
    end

    def button_fields
      {
        "checkifsingle" => @adapter.single?,
        "checkifmarriedfilingjoint" => @adapter.married_joint?,
        "checkifmarriedfilingseparately" => @adapter.married_separately?,
        "checkifheadofhousehold" => @adapter.head_of_household?,
        "checkifqualifyingwidower" => @adapter.qualified_widow?,
      }
    end

    def do_buttons(fields)
      fields.each do |name, value|
        if value
          field = @fields.find { |f| f.full_field_name == name }
          raise "Cannot find PDF field #{name}" if field.nil?
          field.field_value = value
        end
      end
    end

    def write_texts(fields)
      fields.each do |name, value|
        if value
          field = @fields.find { |f| f.full_field_name == name }
          raise "Cannot find PDF field #{name}" if field.nil?
          field.field_value = value
        end
      end
    end

    def draw_fields
      #create_canvas
      write_texts(text_fields)
      do_buttons(button_fields)
      #draw_number_fields(money_fields)
    end
  end
end
