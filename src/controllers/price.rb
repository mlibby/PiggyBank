module PiggyBank
  class App < Sinatra::Base
    def price_find(id)
      PiggyBank::Price.find(price_id: id)
    end

    def price_index
      @prices = PiggyBank::Price.eager(:commodity, :currency)
      haml_layout :"price/index"
    end

    #     def price_find(id)
    #       PiggyBank::Price.find(price_id: id)
    #     end

    #     def price_index
    #       @prices = PiggyBank::Price.as_chart
    #       haml_layout :"price/index"
    #     end

    def price_new
      @method = "POST"
      @action = "/price"
      @header = "New Price"
      haml_layout :"price/edit"
    end

    def price_create(params)
      @price = PiggyBank::Price.create(
        quote_date: params["quote_date"],
        commodity_id: params["commodity_id"],
        currency_id: params["currency_id"],
        value: params["value"],
      )

      flash[:success] = "Price created."
      redirect to "/prices"
    end

    #     def price_view
    #       haml_layout :"price/view"
    #     end

    #     def price_edit
    #       @action = "/price/#{@price.price_id}"
    #       @method = "PUT"
    #       @header = "Edit Price"

    #       haml_layout :"price/edit"
    #     end

    #     def price_update
    #       haml :"price/view"
    #     end

    #     def price_diff(orig_price, new_price)
    #       @price = orig_price
    #       @new_price = new_price
    #       haml :"price/diff"
    #     end

    #     def price_confirm
    #       @action = "/price/#{@price.price_id}"
    #       @method = "DELETE"

    #       haml_layout :"price/delete"
    #     end

    #     def price_delete
    #       flash[:success] = "Price '#{@price.name}' deleted."
    #       @price.destroy
    #       redirect to "/prices"
    #     end

    # ROUTES

    get "/prices" do
      price_index
    end

    get "/price" do
      @price = PiggyBank::Price.new
      price_new
    end

    post "/price" do
      # if params["_token"] != PiggyBank::App.token
      #   @price = PiggyBank::Price.new
      #   @price.set_fields params, PiggyBank::Price.update_fields
      #   flash.now[:danger] = "Failed to create, please try again"
      #   halt 403, price_new
      # else
        price_create params
      # end
    end

    #     get "/price/:id" do |id|
    #       @price = price_find id
    #       if params.has_key? "edit"
    #         price_edit
    #       elsif params.has_key? "delete"
    #         price_confirm
    #       else
    #         price_view
    #       end
    #     end

    #     put "/price/:id" do |id|
    #       @price = price_find id
    #       if params["_token"] != PiggyBank::App.token
    #         @price.set_fields params, PiggyBank::Price.update_fields
    #         flash.now[:danger] = "Failed to save changes, please try again"
    #         halt 403, price_edit
    #       elsif params["version"] != @price.version
    #         orig = @price.clone
    #         @price.set_fields params, PiggyBank::Price.update_fields
    #         flash.now[:danger] = "Someone else updated this price, please confirm changes"
    #         halt 409, price_diff(orig, @price)
    #       else
    #         @price.update_fields params, PiggyBank::Price.update_fields
    #         price_update
    #       end
    #     end

    #     delete "/price/:id" do |id|
    #       @price = price_find id
    #       if params["_token"] != PiggyBank::App.token
    #         flash.now[:danger] = "Failed to delete, please try again"
    #         halt 403, price_confirm
    #       elsif params["version"] != @price.version
    #         flash.now[:danger] = "Someone else updated this price, please re-confirm delete"
    #         halt 409, price_confirm
    #       else
    #         price_delete
    #       end
    #     end
  end
end
