class PiggyBank < Sinatra::Base
  get "/commodities" do
    erb :"commodity/index",
        layout: :layout #,
    #locals: { commodities: DB[:commodity].all.to_s }
  end
end
