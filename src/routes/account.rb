get "/accounts" do
  erb :"account/index",
      layout: :layout,
      locals: { accounts: DB[:account].all.to_s }
end
