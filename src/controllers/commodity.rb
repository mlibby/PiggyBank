module PiggyBank
  class App < Sinatra::Base
    def commodity_index
      index = PiggyBank::Commodity.all
      haml :"commodity/index",
        layout: :layout,
        locals: { commodities: index }
    end

    def commodity_new
      commodity = PiggyBank::Commodity.new
      haml :"commodity/form",
           layout: :layout,
           locals: {
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

    def commodity_read(id)
      PiggyBank::Commodity.where(commodity_id: id).single_record
    end

    def commodity_view(id)
      commodity = commodity_read id
      haml :"commodity/view",
           layout: :layout,
           locals: {
             commodity: commodity,
           }
    end

    def commodity_edit(id)
      commodity = commodity_read id
      haml :"commodity/form",
           layout: :layout,
           locals: {
             header: "Edit Commodity",
             commodity: commodity,
           }
    end

    def commodity_update(id, params)
      commodity = commodity_read id

      fields = [:name, :description, :type, :ticker, :fraction]
      commodity.update_fields params, fields

      haml :"commodity/view",
           layout: :layout,
           locals: {
             commodity: commodity,
           }
    end

    def commodity_confirm(id)
      commodity = commodity_read id
      haml :"commodity/delete",
           layout: :layout,
           locals: {
             commodity: commodity,
           }
    end

    def commodity_delete(id)
      commodity = commodity_read id
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
      if params.has_key? "edit"
        commodity_edit id
      elsif params.has_key? "delete"
        commodity_confirm id
      else
        commodity_view id
      end
    end

    post "/commodity" do
      commodity_create params
    end

    put "/commodity/:id" do |id|
      commodity_update id, params
    end

    delete "/commodity/:id" do |id|
      commodity_delete id
    end
  end
end
