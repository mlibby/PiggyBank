class PiggyBank < Sinatra::Base
  get "/txs" do
    erb :"tx/index",
        layout: :layout
    #locals: { txs: DB[:tx].all.to_s }
  end
end
