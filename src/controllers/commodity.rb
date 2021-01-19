module PiggyBank
  class App < Sinatra::Base
    def commodity_find(id)
      PiggyBank::Commodity.find(commodity_id: id)
    end

    def commodity_index
      index = PiggyBank::Commodity.all
      haml :"commodity/index",
        layout: :layout,
        locals: { commodities: index }
    end

    def commodity_new(commodity = nil)
      commodity ||= PiggyBank::Commodity.new
      haml :"commodity/form",
           layout: :layout,
           locals: {
             method: "POST",
             action: "/commodity",
             header: "New Commodity",
             commodity: commodity,
           }
    end

    def commodity_create(params)
      name = params["name"]
      commodity = PiggyBank::Commodity.create(
        name: name,
        description: params["description"],
        type: params["type"],
        ticker: params["ticker"],
        fraction: params["fraction"],
      )

      flash[:success] = "Commodity '#{name}' created."
      redirect to "/commodities"
    end

    def commodity_view(commodity)
      haml :"commodity/view",
           layout: :layout,
           locals: {
             commodity: commodity,
           }
    end

    def commodity_edit(commodity)
      haml :"commodity/form",
           layout: :layout,
           locals: {
             action: "/commodity/#{commodity.commodity_id}",
             method: "PUT",
             header: "Edit Commodity",
             commodity: commodity,
           }
    end

    def commodity_update(commodity)
      haml :"commodity/view",
           layout: :layout,
           locals: {
             commodity: commodity,
           }
    end

    def commodity_diff(orig_commodity, new_commodity)
      haml :"commodity/diff",
           layout: :layout,
           locals: {
             orig_commodity: orig_commodity,
             new_commodity: new_commodity,
           }
    end

    def commodity_confirm(commodity)
      haml :"commodity/delete",
           layout: :layout,
           locals: {
             action: "/commodity/#{commodity.commodity_id}",
             method: "DELETE",
             commodity: commodity,
           }
    end

    def commodity_delete(commodity)
      commodity.destroy
      flash[:success] = "Commodity '#{commodity.name}' deleted."
      redirect to "/commodities"
    end

    get "/commodities" do
      commodity_index
    end

    get "/commodity" do
      commodity_new
    end

    get "/commodity/:id" do |id|
      commodity = commodity_find id
      if params.has_key? "edit"
        commodity_edit commodity
      elsif params.has_key? "delete"
        commodity_confirm commodity
      else
        commodity_view commodity
      end
    end

    post "/commodity" do
      if params["_token"] != PiggyBank::App.token
        commodity = PiggyBank::Commodity.new
        commodity.set_fields params, PiggyBank::Commodity.update_fields
        flash.now[:danger] = "Failed to create, please try again"
        halt 403, commodity_new(commodity)
      else
        commodity_create params
      end
    end

    put "/commodity/:id" do |id|
      commodity = commodity_find id
      if params["_token"] != PiggyBank::App.token
        commodity.set_fields params, PiggyBank::Commodity.update_fields
        flash.now[:danger] = "Failed to save changes, please try again"
        halt 403, commodity_edit(commodity)
      elsif params["version"] != commodity.version
        orig = commodity.clone
        commodity.set_fields params, PiggyBank::Commodity.update_fields
        flash.now[:danger] = "Someone else updated this commodity"
        halt 409, commodity_diff(orig, commodity)
      else
        commodity.update_fields params, PiggyBank::Commodity.update_fields
        commodity_update commodity
      end
    end

    delete "/commodity/:id" do |id|
      commodity = commodity_find id
      if params["_token"] != PiggyBank::App.token
        flash.now[:danger] = "Failed to delete, please try again"
        halt 403, commodity_confirm(commodity)
      else
        commodity_delete commodity
      end
    end
  end
end
