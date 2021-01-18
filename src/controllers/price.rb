module PiggyBank
  class App < Sinatra::Base
    get "/prices" do
      haml :"price/index",
           layout: :layout #,
      # TODO: get list of prices
      #locals: { prices: DB[:price].all.to_s }
    end

    # TODO: GET /price/new = new price form

    # TODO: POST /price = create price

    # TODO: GET /price/:id = edit price form

    # TODO: PUT /price/:id = update price

    # TODO: GET /price/delete = confirm delete

    # TODO: DELETE /price/:id = delete price
  end
end
