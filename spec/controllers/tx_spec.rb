require_relative "../spec_helper.rb"

describe PiggyBank::App do
  include Rack::Test::Methods

  before(:example) do
    seed_db
  end

  let(:app) { PiggyBank::App.new }

  context "get /txs" do
    it "has a list of transactions" do
      response = get "/txs"
      expect(response.status).to eq 200
      expect(response.body).to have_tag "h1", text: "Transactions"
    end
  end

  # context "GET /tx" do
  #   let(:response) {
  #     liabilities = PiggyBank::Tx.find(name: "Liabilities")
  #     get "/tx?parent_id=#{liabilities.tx_id}"
  #   }
  #   it { expect(response.status).to eq 200 }
  #   it { expect(response.body).to include "New Tx" }
  #   it "has a form" do
  #     expect(response.body).to have_tag(
  #       "form",
  #       with: {
  #         method: "POST",
  #         action: "/tx",
  #       },
  #     ) do
  #       with_tag "option", seen: "Liabilities", with: { selected: "selected" }
  #     end
  #   end
  # end

  # def create_params
  #   usd = PiggyBank::Commodity.find(name: "USD")
  #   equity = PiggyBank::Tx.find(name: "Equity")
  #   {
  #     _token: PiggyBank::App.token,
  #     name: "Opening Balances",
  #     type: PiggyBank::Tx::TYPE[:equity],
  #     parent_id: equity.tx_id,
  #     commodity_id: usd.commodity_id,
  #     is_placeholder: false,
  #   }
  # end

  # context "POST /tx" do
  #   let(:response) { post "/tx", create_params }

  #   it "redirects to /txs" do
  #     expect(response.status).to eq 302
  #     location = URI(response.headers["Location"])
  #     expect(location.path).to eq "/txs"
  #     expect(flash).to have_key :success
  #     expect(flash[:success]).to eq "Tx 'Opening Balances' created."
  #   end
  # end

  # context "POST /tx with invalid token" do
  #   let(:response) {
  #     params = create_params
  #     params[:_token] = "bad token"
  #     post "/tx", params
  #   }

  #   it "politely refuses to create" do
  #     expect(response.status).to eq 403
  #     expect(response.body).to have_tag "h1", text: "New Tx"
  #     expect(response.body).to have_tag "div#flash"
  #     expect(response.body).to have_tag "div.flash.danger", text: "Failed to create, please try again"
  #   end
  # end

  # context "GET /tx/:id" do
  #   let(:response) {
  #     mortgage = PiggyBank::Tx.find(name: "Mortgage")
  #     get "/tx/#{mortgage.tx_id}"
  #   }

  #   it { expect(response.status).to eq 200 }
  #   it { expect(response.body).to match /Tx 'Liabilities:Mortgage'/ }
  # end

  # context "GET /tx/:id?edit" do
  #   let(:response) {
  #     mortgage = PiggyBank::Tx.find(name: "Mortgage")
  #     get "/tx/#{mortgage.tx_id}?edit"
  #   }
  #   it { expect(response.status).to eq 200 }
  #   it { expect(response.body).to include "Edit Tx" }

  #   it "has an edit form" do
  #     version = PiggyBank::Tx.find(name: "Mortgage").version
  #     expect(response.body).to have_tag("form", with: { method: "POST" }) do
  #       with_tag "input", with: { name: "_token", type: "hidden" }
  #       with_tag "input", with: { name: "_method", type: "hidden", value: "PUT" }
  #       with_tag "input", with: { name: "version", type: "hidden", value: version }
  #     end
  #   end
  # end

  # context "GET /tx/:id?delete" do
  #   it "has a delete confirmation form" do
  #     mortgage = PiggyBank::Tx.find(name: "Mortgage")
  #     response = get "/tx/#{mortgage.tx_id}?delete"
  #     expect(response.body).to include "Delete Tx?"
  #     expect(response.status).to eq 200
  #     action = "/tx/#{mortgage.tx_id}"
  #     expect(response.body).to have_tag("form", with: { method: "POST", action: action }) do
  #       with_tag "input", with: { name: "_token", type: "hidden" }
  #       with_tag "input", with: { name: "_method", type: "hidden", value: "DELETE" }
  #       with_tag "input", with: { name: "version", type: "hidden", value: mortgage.version }
  #     end
  #   end
  # end

  # def update_params(existing)
  #   {
  #     _token: PiggyBank::App.token,
  #     name: "Home Mortgage",
  #     type: 2,
  #     parent_id: PiggyBank::Tx.find(name: "Assets").tx_id,
  #     commodity_id: PiggyBank::Commodity.find(name: "CAD").commodity_id,
  #     is_placeholder: true,
  #     version: existing.version,
  #   }
  # end

  # context "PUT /tx/:id with valid params" do
  #   it "updates the DB" do
  #     mortgage = PiggyBank::Tx.find(name: "Mortgage")
  #     response = put "/tx/#{mortgage.tx_id}", update_params(mortgage)

  #     expect(response.status).to eq 200

  #     mortgage = PiggyBank::Tx.find(name: "Home Mortgage")
  #     assets = PiggyBank::Tx.find(name: "Assets")
  #     cad = PiggyBank::Commodity.find(name: "CAD")

  #     expect(mortgage.type).to eq 2
  #     expect(mortgage.parent_id).to eq assets.tx_id
  #     expect(mortgage.commodity_id).to eq cad.commodity_id
  #     expect(mortgage.is_placeholder).to be true
  #   end
  # end

  # context "PUT /tx/:id with invalid token" do
  #   let(:response) {
  #     mortgage = PiggyBank::Tx.find(name: "Mortgage")
  #     params = update_params(mortgage)
  #     params[:_token] = "bad token"
  #     put "/tx/#{mortgage.tx_id}", params
  #   }

  #   it "politely refuses to update" do
  #     expect(response.status).to eq 403
  #     expect(response.body).to have_tag "h1", text: "Edit Tx"
  #     expect(response.body).to have_tag "div#flash"
  #     expect(response.body).to have_tag "div.flash.danger", text: "Failed to save changes, please try again"
  #   end
  # end

  # context "PUT /tx/:id with version mismatch" do
  #   it "politely refuses to update" do
  #     mortgage = PiggyBank::Tx.find(name: "Mortgage")
  #     params = update_params(mortgage)
  #     params[:version] = "bad version"
  #     response = put "/tx/#{mortgage.tx_id}", params
  #     expect(response.status).to eq 409
  #     expect(response.body).to have_tag "h1", text: "Compare Old/New Tx"
  #     expect(response.body).to have_tag "div#flash"
  #     expect(response.body).to have_tag "div.flash.danger", text: "Someone else updated this tx, please confirm changes"
  #   end
  # end

  # context "DELETE /tx/:id" do
  #   it "deletes the tx" do
  #     mortgage = PiggyBank::Tx.find(name: "Mortgage")
  #     response = delete "/tx/#{mortgage.tx_id}", {
  #       _token: PiggyBank::App.token,
  #       version: mortgage.version,
  #     }
  #     expect(response.status).to eq 302
  #     location = URI(response.headers["Location"])
  #     expect(location.path).to eq "/txs"
  #     expect(flash).to have_key :success
  #     expect(flash[:success]).to eq "Tx 'Mortgage' deleted."
  #   end
  # end

  # context "DELETE /tx/:id with invalid token" do
  #   it "politely refuses to delete" do
  #     mortgage = PiggyBank::Tx.find(name: "Mortgage")
  #     params = update_params(mortgage)
  #     params["_token"] = "bad penny"
  #     response = delete "/tx/#{mortgage.tx_id}", params
  #     expect(response.status).to eq 403
  #     expect(response.body).to have_tag "h1", text: "Delete Tx?"
  #     expect(response.body).to have_tag "div#flash"
  #     expect(response.body).to have_tag "div.flash.danger", text: "Failed to delete, please try again"
  #   end
  # end

  # context "DELETE /tx/:id with version mismatch" do
  #   it "politely refuses to delete" do
  #     mortgage = PiggyBank::Tx.find(name: "Mortgage")
  #     params = update_params(mortgage)
  #     params[:version] = "bad version"
  #     response = delete "/tx/#{mortgage.tx_id}", params

  #     expect(response.status).to eq 409
  #     expect(response.body).to have_tag "h1", text: "Delete Tx?"
  #     expect(response.body).to have_tag "div#flash"
  #     expect(response.body).to have_tag "div.flash.danger", text: "Someone else updated this tx, please re-confirm delete"
  #   end
  # end
end

# TODO: pass list of txs

# TODO: GET /tx = new tx form
# TODO: POST /tx = create tx
# TODO: POST /tx CSRF protection

# TODO: GET /tx/:id = view tx
# TODO: GET /tx/:id?edit = edit tx form
# TODO: PUT /tx/:id = update tx
# TODO: PUT /tx/:id CSRF prevention
# TODO: PUT /tx/:id version mismatch

# TODO: GET /tx/:id?delete = confirm delete form
# TODO: DELETE /tx/:id = delete tx
# TODO: DELETE /tx/:id CSRF prevention
# TODO: DELETE /tx/:id version mismatch
