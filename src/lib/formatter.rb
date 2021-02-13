module PiggyBank
  class Formatter
    def as_currency(value)
      segments = []
      value.round.digits.each_slice(3) { |s| segments << s.join }
      curr = segments.join(",").reverse
      "#{curr}."
    end
  
    def as_spaced_ssn(ssn)
      return if ssn.nil? || ssn == ""
      ssn = ssn.tr "-", ""
      ssn.insert 3, " "
      ssn.insert 6, " "
    end
  end
end