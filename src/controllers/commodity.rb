module PiggyBank
  class App < Sinatra::Base
    get "/commodities" do
      erb :"commodity/index",
        layout: :layout,
        locals: { commodities: PiggyBank::Commodity.all }
    end

    get "/commodity/new" do
      erb :"commodity/form",
          layout: :layout,
          locals: {
            header: "New Commodity",
            commodity: PiggyBank::Commodity.new,
          }
    end

    get "/commodity/edit/:commodity_id" do
      commodity = PiggyBank::Commodity.where(commodity_id: params["commodity_id"]).single_record
      erb :"commodity/form",
          layout: :layout,
          locals: {
            header: "Edit Commodity",
            commodity: commodity
          }
    end

    get "/commodity/delete/:commodity_id" do
      commodity = PiggyBank::Commodity.where(commodity_id: params["commodity_id"]).single_record
      erb :"commodity/delete",
          layout: :layout ,
          locals: {
            commodity: commodity
          }
    end
  end
end
