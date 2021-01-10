get "/txs" do
  erb :"tx/index",
      layout: :layout,
      locals: { txs: pp(DB[:tx].all) }
end
