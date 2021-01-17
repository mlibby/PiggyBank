module PiggyBank
  class App < Sinatra::Base
    get "/txs" do
      haml :"tx/index",
          layout: :layout
      #locals: { txs: DB[:tx].all.to_s }
    end
  end
end
