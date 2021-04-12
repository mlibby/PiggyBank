require "bigdecimal"

def _d(value = nil)
  value = "0.0" if value.nil? || value.empty?
  BigDecimal(value)
end
