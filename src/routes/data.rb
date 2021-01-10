get "/api_keys" do
  erb :"data/api_keys",
      layout: :layout,
      locals: {api_keys: pp(DB[:api_key].all.to_s)}
end

get "/import" do
  erb :"data/import",
      layout: :layout
end

get "/ofx" do
  erb :"data/ofx",
      layout: :layout
end

get "/receipt" do
  erb :"data/receipt",
      layout: :layout
end
