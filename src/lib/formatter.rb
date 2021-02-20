module PiggyBank
  class Formatter
    def as_currency(value)
      return "" if value.nil? || value == 0
      segments = []
      value.round.digits.each_slice(3) { |s| segments << s.join }
      curr = segments.join(",").reverse
      "#{curr}."
    end
  
    def as_1040_ssn(ssn)
      return if ssn.nil? || ssn == ""
      ssn = ssn.tr "-", ""
      "#{ssn[0]} #{ssn[1]} #{ssn[2]}     #{ssn[3]} #{ssn[4]}     #{ssn[5]} #{ssn[6]} #{ssn[7]} #{ssn[8]}     "
    end
  end
end