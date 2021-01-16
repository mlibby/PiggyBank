module PiggyBank
  class App < Sinatra::Base
    get "/commodities" do
      erb :"commodity/index",
        layout: :layout,
        locals: { commodities: PiggyBank::Commodity.all }
    end
  end
end
