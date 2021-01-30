module PiggyBank
  class App < Sinatra::Base
    get "/report" do
      haml_layout :"report/index"
    end

    get "/report/balance" do
      haml_layout :"report/balance"
    end

    get "/report/income" do
      haml_layout :"report/income"
    end

    get "/report/cash" do
      haml_layout :"report/cash"
    end
  end
end

# ZZZ: GET /report/balance
# ZZZ: GET /report/income
# ZZZ: GET /report/cash
