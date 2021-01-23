module PiggyBank
  class App < Sinatra::Base
    def commodity_find(id)
      PiggyBank::Commodity.find(commodity_id: id)
    end

    def commodity_index
      @commodities = PiggyBank::Commodity.all
      haml_layout :"commodity/index"
    end

    def commodity_new
      @commodity ||= PiggyBank::Commodity.new

      @method = "POST"
      @action = "/commodity"
      @header = "New Commodity"

      haml_layout :"commodity/edit"
    end

    def commodity_create(params)
      name = params["name"]

      @commodity = PiggyBank::Commodity.create(
        name: name,
        description: params["description"],
        type: params["type"],
        ticker: params["ticker"],
        fraction: params["fraction"],
      )

      flash[:success] = "Commodity '#{name}' created."
      redirect to "/commodities"
    end

    def commodity_view
      haml_layout :"commodity/view"
    end

    def commodity_edit
      @action = "/commodity/#{@commodity.commodity_id}"
      @method = "PUT"
      @header = "Edit Commodity"

      haml_layout :"commodity/edit"
    end

    def commodity_update
      haml :"commodity/view"
    end

    def commodity_diff(orig_commodity, new_commodity)
      @commodity = orig_commodity
      @new_commodity = new_commodity
      haml :"commodity/diff"
    end

    def commodity_confirm
      @action = "/commodity/#{@commodity.commodity_id}"
      @method = "DELETE"

      haml_layout :"commodity/delete"
    end

    def commodity_delete
      flash[:success] = "Commodity '#{@commodity.name}' deleted."
      @commodity.destroy
      redirect to "/commodities"
    end

    # ROUTES

    get "/commodities" do
      commodity_index
    end

    get "/commodity" do
      commodity_new
    end

    get "/commodity/:id" do |id|
      @commodity = commodity_find id
      if params.has_key? "edit"
        commodity_edit
      elsif params.has_key? "delete"
        commodity_confirm
      else
        commodity_view
      end
    end

    post "/commodity" do
      if params["_token"] != PiggyBank::App.token
        @commodity = PiggyBank::Commodity.new
        @commodity.set_fields params, PiggyBank::Commodity.update_fields
        flash.now[:danger] = "Failed to create, please try again"
        halt 403, commodity_new
      else
        commodity_create params
      end
    end

    put "/commodity/:id" do |id|
      @commodity = commodity_find id
      if params["_token"] != PiggyBank::App.token
        @commodity.set_fields params, PiggyBank::Commodity.update_fields
        flash.now[:danger] = "Failed to save changes, please try again"
        halt 403, commodity_edit
      elsif params["version"] != @commodity.version
        orig = @commodity.clone
        @commodity.set_fields params, PiggyBank::Commodity.update_fields
        flash.now[:danger] = "Someone else updated this commodity, please confirm changes"
        halt 409, commodity_diff(orig, @commodity)
      else
        @commodity.update_fields params, PiggyBank::Commodity.update_fields
        commodity_update
      end
    end

    delete "/commodity/:id" do |id|
      @commodity = commodity_find id
      if params["_token"] != PiggyBank::App.token
        flash.now[:danger] = "Failed to delete, please try again"
        halt 403, commodity_confirm
      elsif params["version"] != @commodity.version
        flash.now[:danger] = "Someone else updated this commodity, please re-confirm delete"
        halt 409, commodity_confirm
      else
        commodity_delete
      end
    end
  end
end
