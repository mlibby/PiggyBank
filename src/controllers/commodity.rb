module PiggyBank
  class App < Sinatra::Base
    get "/commodities" do
      erb :"commodity/index",
        layout: :layout,
        locals: { commodities: PiggyBank::Commodity.all }
    end

    get "/commodity/new" do
      erb :"commodity/form",
          layout: :layout,
          locals: { 
            header: "New Commodity", 
            commodity: PiggyBank::Commodity.new
          }
    end
  end
end
