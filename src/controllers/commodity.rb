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

    post "/commodity/new" do
      name = params["name"]
      flash[:success] = "Commodity '#{name}' created."
      redirect to "/commodities"
    end

    get "/commodity/edit/:commodity_id" do
      commodity = PiggyBank::Commodity.where(commodity_id: params["commodity_id"]).single_record
      haml :"commodity/form",
          layout: :layout,
          locals: {
            header: "Edit Commodity",
            commodity: commodity,
          }
    end

    get "/commodity/delete/:commodity_id" do
      commodity = PiggyBank::Commodity.where(commodity_id: params["commodity_id"]).single_record
      haml :"commodity/delete",
          layout: :layout,
          locals: {
            commodity: commodity,
          }
    end
  end
end
