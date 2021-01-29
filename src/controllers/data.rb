module PiggyBank
  class App < Sinatra::Base
    get "/import" do
      haml :"data/import",
           layout: :layout
    end

    get "/receipt" do
      haml :"data/receipt",
           layout: :layout
    end
  end
end

# ZZZ move api_key to its own controller
# ZZZ split ofx to its own controller
