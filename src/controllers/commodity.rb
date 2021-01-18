module PiggyBank
  class App < Sinatra::Base
    get "/commodities" do
      haml :"commodity/index",
        layout: :layout,
        locals: { commodities: PiggyBank::Commodity.all }
    end

    get "/commodity/new" do
      haml :"commodity/form",
          layout: :layout,
          locals: {
            header: "New Commodity",
            commodity: PiggyBank::Commodity.new,
          }
    end

    # FIXME: shorten to POST /commodity
    post "/commodity/new" do
      # TODO: save new commodity
      name = params["name"]
      flash[:success] = "Commodity '#{name}' created."
      redirect to "/commodities"
    end

    # FIXME: shorten to /commodity/:id 
    get "/commodity/edit/:commodity_id" do
      commodity = PiggyBank::Commodity.where(commodity_id: params["commodity_id"]).single_record
      haml :"commodity/form",
          layout: :layout,
          locals: {
            header: "Edit Commodity",
            commodity: commodity,
          }
    end

    # TODO: PUT /commodity/:id = save updated commodity

    get "/commodity/delete/:commodity_id" do
      commodity = PiggyBank::Commodity.where(commodity_id: params["commodity_id"]).single_record
      haml :"commodity/delete",
          layout: :layout,
          locals: {
            commodity: commodity,
          }
    end

    # TODO: DELETE /commodity/:id = delete commodity
  end
end
