module PiggyBank
  class App < Sinatra::Base
    get "/report" do
      haml :"report/index",
           layout: :layout
    end

    # TODO: GET /report/balance

    # TODO: GET /report/income

    # TODO: GET /report/cash
    
  end
end
