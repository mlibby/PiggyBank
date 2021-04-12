require "singleton"
require_relative "../base"

module PiggyBank::Tax::Form::Adapter::MN
  class M1MA < PiggyBank::Tax::Form::Adapter::Base
    include Singleton

    attr_accessor :mn_m1

    def initialize
      super
      @mn_m1w = PiggyBank::Tax::Form::Adapter::MN::M1W.instance
    end

    def total_wages(person_number)
      total = _d("0")
      total += @mn_m1w.line_1d1 if @mn_m1w.line_1a1 == person_number.to_s
      total += @mn_m1w.line_1d2 if @mn_m1w.line_1a2 == person_number.to_s
      total += @mn_m1w.line_1d3 if @mn_m1w.line_1a3 == person_number.to_s
      total
    end

    def line_1a
      total_wages(1)
    end

    def line_1b
      total_wages(2)
    end

    def line_5a
      line_1a
    end

    def line_5b
      line_1b
    end

    def line_6
      [line_5a, line_5b].min
    end

    def line_7
      @mn_m1.line_9
    end

    def credit_table
      [
        %w(25000 27000 17 17 17 0 0 0 0 0 0 0 0),
        %w(27000 29000 46 46 46 0 0 0 0 0 0 0 0),
        %w(29000 31000 75 75 75 34 0 0 0 0 0 0 0),
        %w(31000 33000 104 104 104 84 0 0 0 0 0 0 0),
        %w(33000 35000 133 133 133 133 0 0 0 0 0 0 0),
        %w(35000 37000 154 162 162 162 0 0 0 0 0 0 0),
        %w(37000 39000 154 191 191 191 24 0 0 0 0 0 0),
        %w(39000 41000 144 210 210 210 65 0 0 0 0 0 0),
        %w(41000 43000 115 210 210 210 86 0 0 0 0 0 0),
        %w(43000 45000 86 210 210 210 107 0 0 0 0 0 0),
        %w(45000 47000 57 210 210 210 128 0 0 0 0 0 0),
        %w(47000 49000 28 210 210 210 149 0 0 0 0 0 0),
        %w(49000 51000 0 210 210 210 170 0 0 0 0 0 0),
        %w(51000 53000 0 210 210 210 191 0 0 0 0 0 0),
        %w(53000 55000 0 210 210 210 210 2 0 0 0 0 0),
        %w(55000 57000 0 202 210 210 210 23 0 0 0 0 0),
        %w(57000 59000 0 173 210 210 210 44 0 0 0 0 0),
        %w(59000 61000 0 144 210 210 210 65 0 0 0 0 0 0),
        %w(61000 63000 0 115 210 210 210 86 17 17 17 0 0 0),
        %w(63000 65000 0 86 210 210 210 107 38 38 38 0 0 0),
        %w(65000 67000 0 57 210 210 210 128 59 59 59 0 0 0),
        %w(67000 69000 0 28 210 210 210 149 80 80 80 0 0 0),
        %w(69000 71000 0 0 210 210 210 170 101 101 101 0 0 0),
        %w(71000 73000 0 0 210 210 210 191 122 122 122 2 0 0),
        %w(73000 75000 0 0 210 210 210 210 143 143 143 63 0 0),
        %w(75000 77000 0 0 202 210 210 210 164 164 164 124 0 0),
        %w(77000 79000 0 0 173 210 210 210 185 185 185 185 0 0),
        %w(79000 81000 0 0 144 210 210 210 206 206 206 206 0 0),
        %w(81000 83000 0 0 115 210 210 210 227 227 227 227 0 0),
        %w(83000 85000 0 0 86 210 210 210 248 248 248 248 0 0),
        %w(85000 87000 0 0 57 210 210 210 269 269 269 269 29 0),
        %w(87000 89000 0 0 28 210 210 210 290 290 290 290 90 0),
        %w(89000 91000 0 0 0 210 210 210 311 311 311 311 151 0),
        %w(91000 93000 0 0 0 210 210 210 332 332 332 332 212 0),
        %w(93000 95000 0 0 0 210 210 210 351 353 353 353 273 0),
        %w(95000 97000 0 0 0 202 210 210 351 374 374 374 334 0),
        %w(97000 99000 0 0 0 173 210 210 351 395 395 395 395 0),
        %w(99000 101000 0 0 0 144 210 210 351 416 416 416 416 56),
        %w(101000 103000 0 0 0 104 199 199 340 426 426 426 426 106),
      ]
    end

    def lookup_credit
      if line_6 < 25000 || line_7 < 40000
        return _d("0")
      end

      credit_table.each do |row|
        row = row.map { |s| s.to_i }
        if row[0] <= line_6 && line_6 < row[1]
          index = ((line_7.to_i - 40000) / 20000) + 2
          return row[index]
        end
        _d("0")
      end
    end

    def line_8
      lookup_credit
    end
  end
end