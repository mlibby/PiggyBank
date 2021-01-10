get "/prices" do
  erb :"price/index",
      layout: :layout,
      locals: { prices: pp(DB[:price].all) }
end