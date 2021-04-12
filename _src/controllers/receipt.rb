module PiggyBank
  class App < Sinatra::Base
    get "/receipts" do
      erb_layout :"receipt/index"
    end
  end
end

# ZZZ move api_key to its own controller
# ZZZ split ofx to its own controller
