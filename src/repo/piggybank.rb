require_relative "./models/account.rb"
require_relative "./models/commodity.rb"

module Piggy
  class Bank
    def Bank.new_version
      DateTime.now.new_offset(0).to_s
    end
  end
end
