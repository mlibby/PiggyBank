get "/prices" do
  erb :"price/index",
      layout: :layout,
      locals: { prices: DB[:price].all.to_s }
end