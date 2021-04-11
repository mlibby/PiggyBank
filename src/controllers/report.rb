module PiggyBank
  class App < Sinatra::Base
    get "/report" do
      erb_layout :"report/index"
    end

    get "/report/balance" do
      erb_layout :"report/balance"
    end

    get "/report/income" do
      erb_layout :"report/income"
    end

    get "/report/cash" do
      erb_layout :"report/cash"
    end
  end
end

# ZZZ: GET /report/balance
# ZZZ: GET /report/income
# ZZZ: GET /report/cash
