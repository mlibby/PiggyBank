module PiggyBank
  class App < Sinatra::Base
    # TODO move api_key to its own controller

    get "/api_keys" do
      haml :"data/api_keys",
           layout: :layout #,
      #locals: { api_keys: DB[:api_key].all.to_s }
    end

    # TODO GET /api_key/:id = edit api_key form

    # TODO PUT /api_key/:id - update api_key

    # TODO GET /api_key/new = new api_key form

    # TODO POST /api_key = save new api_key

    # TODO GET /api_key/delete/:id = confirm delete

    # TODO DELETE /api_key/:id = delete api_key

    get "/import" do
      haml :"data/import",
           layout: :layout
    end

    # TODO split ofx to its own controller
    
    get "/ofxs" do
      haml :"data/ofx",
           layout: :layout
      # TODO: get table of OFX configs
    end

    # TODO GET /ofx/:id = edit ofx form

    # TODO PUT /ofx/:id - update ofx

    # TODO GET /ofx/new = new ofx form

    # TODO POST /ofx = save new ofx

    # TODO GET /ofx/delete/:id = confirm delete

    # TODO DELETE /ofx/:id = delete ofx

    get "/receipt" do
      haml :"data/receipt",
           layout: :layout
    end
  end
end
