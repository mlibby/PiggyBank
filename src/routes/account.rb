get "/accounts" do
  erb :"account/index",
      layout: :layout,
      locals: { accounts: pp(DB[:account].all) }
end
