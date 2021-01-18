module PiggyBank
  class App < Sinatra::Base

    # TODO: get a tx list

    get "/txs" do
      haml :"tx/index",
          layout: :layout
      #locals: { txs: DB[:tx].all.to_s }
    end

    # TODO: GET /tx/new = new tx form

    # TODO: POST /tx = create tx

    # TODO: GET /tx/:id = edit tx form

    # TODO: PUT /tx/:id = update tx

    # TODO: GET /tx/delete = confirm delete

    # TODO: DELETE /tx/:id = delete tx
  end
end
