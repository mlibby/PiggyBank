module PiggyBank
  class App < Sinatra::Base
    get "/api_keys" do
      haml :"data/api_keys",
           layout: :layout #,
      #locals: { api_keys: DB[:api_key].all.to_s }
    end

    get "/import" do
      haml :"data/import",
           layout: :layout
    end

    get "/ofx" do
      haml :"data/ofx",
           layout: :layout
    end

    get "/receipt" do
      haml :"data/receipt",
           layout: :layout
    end
  end
end
