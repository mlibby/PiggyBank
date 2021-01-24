require_relative "../spec_helper.rb"

describe PiggyBank::App do
  include Rack::Test::Methods

  let(:app) { PiggyBank::App.new }

  context "get /prices" do
    let(:response) { get "/prices" }

    it { expect(response.status).to eq 200 }
    it { expect(response.body).to include "Prices" }
  end

  # context "GET /price" do
  #   let(:response) {
  #     liabilities = PiggyBank::price.find(name: "Liabilities")
  #     get "/price?parent_id=#{liabilities.price_id}"
  #   }
  #   it { expect(response.status).to eq 200 }
  #   it { expect(response.body).to include "New price" }
  #   it "has a form" do
  #     expect(response.body).to have_tag(
  #       "form",
  #       with: {
  #         method: "POST",
  #         action: "/price",
  #       },
  #     ) do
  #       with_tag "option", seen: "Liabilities", with: { selected: "selected" }
  #     end
  #   end
  # end

  # def create_params
  #   usd = PiggyBank::Commodity.find(name: "USD")
  #   equity = PiggyBank::price.find(name: "Equity")
  #   {
  #     _token: PiggyBank::App.token,
  #     name: "Opening Balances",
  #     type: PiggyBank::price::TYPE[:equity],
  #     parent_id: equity.price_id,
  #     commodity_id: usd.commodity_id,
  #     is_placeholder: false,
  #   }
  # end

  # context "POST /price" do
  #   let(:response) { post "/price", create_params }

  #   it "redirects to /prices" do
  #     expect(response.status).to eq 302
  #     location = URI(response.headers["Location"])
  #     expect(location.path).to eq "/prices"
  #     expect(flash).to have_key :success
  #     expect(flash[:success]).to eq "price 'Opening Balances' created."
  #   end
  # end

  # context "POST /price with invalid token" do
  #   let(:response) {
  #     params = create_params
  #     params[:_token] = "bad token"
  #     post "/price", params
  #   }

  #   it "politely refuses to create" do
  #     expect(response.status).to eq 403
  #     expect(response.body).to have_tag "h1", text: "New price"
  #     expect(response.body).to have_tag "div#flash"
  #     expect(response.body).to have_tag "div.flash.danger", text: "Failed to create, please try again"
  #   end
  # end

  # context "GET /price/:id" do
  #   let(:response) {
  #     mortgage = PiggyBank::price.find(name: "Mortgage")
  #     get "/price/#{mortgage.price_id}"
  #   }

  #   it { expect(response.status).to eq 200 }
  #   it { expect(response.body).to match /price 'Liabilities:Mortgage'/ }
  # end

  # context "GET /price/:id?edit" do
  #   let(:response) {
  #     mortgage = PiggyBank::price.find(name: "Mortgage")
  #     get "/price/#{mortgage.price_id}?edit"
  #   }
  #   it { expect(response.status).to eq 200 }
  #   it { expect(response.body).to include "Edit price" }

  #   it "has an edit form" do
  #     version = PiggyBank::price.find(name: "Mortgage").version
  #     expect(response.body).to have_tag("form", with: { method: "POST" }) do
  #       with_tag "input", with: { name: "_token", type: "hidden" }
  #       with_tag "input", with: { name: "_method", type: "hidden", value: "PUT" }
  #       with_tag "input", with: { name: "version", type: "hidden", value: version }
  #     end
  #   end
  # end

  # context "GET /price/:id?delete" do
  #   it "has a delete confirmation form" do
  #     mortgage = PiggyBank::price.find(name: "Mortgage")
  #     response = get "/price/#{mortgage.price_id}?delete"
  #     expect(response.body).to include "Delete price?"
  #     expect(response.status).to eq 200
  #     action = "/price/#{mortgage.price_id}"
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
  #     parent_id: PiggyBank::price.find(name: "Assets").price_id,
  #     commodity_id: PiggyBank::Commodity.find(name: "CAD").commodity_id,
  #     is_placeholder: true,
  #     version: existing.version,
  #   }
  # end

  # context "PUT /price/:id with valid params" do
  #   it "updates the DB" do
  #     mortgage = PiggyBank::price.find(name: "Mortgage")
  #     response = put "/price/#{mortgage.price_id}", update_params(mortgage)

  #     expect(response.status).to eq 200

  #     mortgage = PiggyBank::price.find(name: "Home Mortgage")
  #     assets = PiggyBank::price.find(name: "Assets")
  #     cad = PiggyBank::Commodity.find(name: "CAD")

  #     expect(mortgage.type).to eq 2
  #     expect(mortgage.parent_id).to eq assets.price_id
  #     expect(mortgage.commodity_id).to eq cad.commodity_id
  #     expect(mortgage.is_placeholder).to be true
  #   end
  # end

  # context "PUT /price/:id with invalid token" do
  #   let(:response) {
  #     mortgage = PiggyBank::price.find(name: "Mortgage")
  #     params = update_params(mortgage)
  #     params[:_token] = "bad token"
  #     put "/price/#{mortgage.price_id}", params
  #   }

  #   it "politely refuses to update" do
  #     expect(response.status).to eq 403
  #     expect(response.body).to have_tag "h1", text: "Edit price"
  #     expect(response.body).to have_tag "div#flash"
  #     expect(response.body).to have_tag "div.flash.danger", text: "Failed to save changes, please try again"
  #   end
  # end

  # context "PUT /price/:id with version mismatch" do
  #   it "politely refuses to update" do
  #     mortgage = PiggyBank::price.find(name: "Mortgage")
  #     params = update_params(mortgage)
  #     params[:version] = "bad version"
  #     response = put "/price/#{mortgage.price_id}", params
  #     expect(response.status).to eq 409
  #     expect(response.body).to have_tag "h1", text: "Compare Old/New price"
  #     expect(response.body).to have_tag "div#flash"
  #     expect(response.body).to have_tag "div.flash.danger", text: "Someone else updated this price, please confirm changes"
  #   end
  # end

  # context "DELETE /price/:id" do
  #   it "deletes the price" do
  #     mortgage = PiggyBank::price.find(name: "Mortgage")
  #     response = delete "/price/#{mortgage.price_id}", {
  #       _token: PiggyBank::App.token,
  #       version: mortgage.version,
  #     }
  #     expect(response.status).to eq 302
  #     location = URI(response.headers["Location"])
  #     expect(location.path).to eq "/prices"
  #     expect(flash).to have_key :success
  #     expect(flash[:success]).to eq "price 'Mortgage' deleted."
  #   end
  # end

  # context "DELETE /price/:id with invalid token" do
  #   it "politely refuses to delete" do
  #     mortgage = PiggyBank::price.find(name: "Mortgage")
  #     params = update_params(mortgage)
  #     params["_token"] = "bad penny"
  #     response = delete "/price/#{mortgage.price_id}", params
  #     expect(response.status).to eq 403
  #     expect(response.body).to have_tag "h1", text: "Delete price?"
  #     expect(response.body).to have_tag "div#flash"
  #     expect(response.body).to have_tag "div.flash.danger", text: "Failed to delete, please try again"
  #   end
  # end

  # context "DELETE /price/:id with version mismatch" do
  #   it "politely refuses to delete" do
  #     mortgage = PiggyBank::price.find(name: "Mortgage")
  #     params = update_params(mortgage)
  #     params[:version] = "bad version"
  #     response = delete "/price/#{mortgage.price_id}", params

  #     expect(response.status).to eq 409
  #     expect(response.body).to have_tag "h1", text: "Delete price?"
  #     expect(response.body).to have_tag "div#flash"
  #     expect(response.body).to have_tag "div.flash.danger", text: "Someone else updated this price, please re-confirm delete"
  #   end
  # end
end

# TODO: GET /price = new price form
# TODO: POST /price = create price
# TODO: POST /price CSRF protection

# TODO: GET /price/:id = view price
# TODO: GET /price/:id?edit = edit price form
# TODO: PUT /price/:id = update price
# TODO: PUT /price/:id CSRF prevention
# TODO: PUT /price/:id version mismatch

# TODO: GET /price/:id?delete = confirm delete form
# TODO: DELETE /price/:id = delete price
# TODO: DELETE /price/:id CSRF prevention
# TODO: DELETE /price/:id version mismatch
