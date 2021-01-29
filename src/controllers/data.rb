module PiggyBank
  class App < Sinatra::Base
    get "/import" do
      haml :"data/import",
           layout: :layout
    end

    # TODO split ofx to its own controller

    get "/ofx" do
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

# ZZZ move api_key to its own controller
