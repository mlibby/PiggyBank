module PiggyBank
  class App < Sinatra::Base
    get "/prices" do
      haml :"price/index",
          layout: :layout #,
      #locals: { prices: DB[:price].all.to_s }
    end
  end
end
