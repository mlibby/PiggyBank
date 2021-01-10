get "/commodities" do
  erb :"commodity/index",
      layout: :layout,
      locals: { commodities: pp(DB[:commodity].all) }
end
