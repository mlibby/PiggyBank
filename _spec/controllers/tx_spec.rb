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

  context "GET /tx" do
    it "gives a new Transaction form" do
      response = get "/tx"

      expect(response.status).to eq 200
      expect(response.body).to have_tag "h1", text: "New Transaction"
      expect(response.body).to have_tag(
        "form",
        with: {
          method: "POST",
          action: "/tx",
        },
      )
    end
  end

  def create_params
    equity = PiggyBank::Account.find(name: "Equity")
    asset = PiggyBank::Account.find(name: "Assets")
    tx = {
      _token: PiggyBank::App.token,
      post_date: "2021-01-28",
      number: 1,
      description: "opening balance",
      splits: [
        {
          account_id: equity.account_id,
          memo: "",
          amount: -12.34,
          value: -12.34,
        },
        {
          account_id: asset.account_id,
          memo: "",
          amount: 12.34,
          value: 12.34,
        },
      ],
    }
  end

  context "POST /tx" do
    it "redirects to /txs" do
      response = post "/tx", create_params
      expect(response.status).to eq 302
      location = URI(response.headers["Location"])
      expect(location.path).to eq "/txs"
      expect(flash).to have_key :success
      expect(flash[:success]).to eq "Transaction created."
    end
  end

  context "POST /tx with invalid token" do
    it "politely refuses to create" do
      params = create_params
      params[:_token] = "bad token"
      response = post "/tx", params

      expect(response.status).to eq 403
      expect(response.body).to have_tag "h1", text: "New Transaction"
      expect(response.body).to have_tag "div#flash"
      expect(response.body).to have_tag "div.flash.danger", text: "Failed to create, please try again"
    end
  end

  context "GET /tx/:id" do
    it "shows the transaction" do
      tx = PiggyBank::Tx.first
      response = get "/tx/#{tx.tx_id}"

      expect(response.status).to eq 200
      expect(response.body).to have_tag "h1", text: "Transaction"
    end
  end

  context "GET /tx/:id?edit" do
    it "has an edit form" do
      tx = PiggyBank::Tx.first
      response = get "/tx/#{tx.tx_id}?edit"
      expect(response.status).to eq 200
      expect(response.body).to have_tag "h1", text: "Edit Transaction"
      expect(response.body).to have_tag("form", with: { method: "POST" }) do
        with_tag "input", with: { name: "_token", type: "hidden" }
        with_tag "input", with: { name: "_method", type: "hidden", value: "PUT" }
        with_tag "input", with: { name: "version", type: "hidden", value: tx.version }
      end
    end
  end

  context "GET /tx/:id?delete" do
    it "has a delete confirmation form" do
      tx = PiggyBank::Tx.first
      response = get "/tx/#{tx.tx_id}?delete"
      expect(response.body).to include "Delete Transaction?"
      expect(response.status).to eq 200
      expect(response.body).to have_tag(
        "form",
        with: {
          method: "POST",
          action: "/tx/#{tx.tx_id}",
        },
      ) do
        with_tag "input", with: { name: "_token", type: "hidden" }
        with_tag "input", with: { name: "_method", type: "hidden", value: "DELETE" }
        with_tag "input", with: { name: "version", type: "hidden", value: tx.version }
      end
    end
  end

  def update_params(existing)
    {
      _token: PiggyBank::App.token,
      post_date: "2021-01-25",
      number: 4,
      description: "Bitz Booop Beep",
      version: existing.version,
      splits: [
        {
          memo: "foo",
          amount: -45.67,
          value: -45.67,
        },
        {
          memo: "bar",
          amount: 45.67,
          value: 45.67,
        },
      ],
    }
  end

  context "PUT /tx/:id with valid params" do
    it "updates the DB" do
      tx = PiggyBank::Tx.first
      response = put "/tx/#{tx.tx_id}", update_params(tx)

      expect(response.status).to eq 200

      tx = PiggyBank::Tx.find(tx_id: tx.tx_id)

      expect(tx.description).to eq "Bitz Booop Beep"
    end
  end

  context "PUT /tx/:id with invalid token" do
    it "politely refuses to update" do
      tx = PiggyBank::Tx.first
      params = update_params tx
      params[:_token] = "bad token"
      response = put "/tx/#{tx.tx_id}", params
      expect(response.status).to eq 403
      expect(response.body).to have_tag "h1", text: "Edit Transaction"
      expect(response.body).to have_tag "div#flash"
      expect(response.body).to have_tag "div.flash.danger", text: "Failed to save changes, please try again"
    end
  end

  context "PUT /tx/:id with version mismatch" do
    it "politely refuses to update" do
      tx = PiggyBank::Tx.first
      params = update_params tx
      params[:version] = "bad version"
      response = put "/tx/#{tx.tx_id}", params
      expect(response.status).to eq 409
      expect(response.body).to have_tag "h1", text: "Compare Old/New Transaction"
      expect(response.body).to have_tag "div#flash"
      expect(response.body).to have_tag "div.flash.danger", text: "Someone else updated this tx, please confirm changes"
    end
  end

  context "DELETE /tx/:id" do
    it "deletes the tx" do
      tx = PiggyBank::Tx.first
      response = delete "/tx/#{tx.tx_id}", {
        _token: PiggyBank::App.token,
        version: tx.version,
      }
      expect(response.status).to eq 302
      location = URI(response.headers["Location"])
      expect(location.path).to eq "/txs"
      expect(flash).to have_key :success
      expect(flash[:success]).to eq "Transaction deleted."
    end
  end

  context "DELETE /tx/:id with invalid token" do
    it "politely refuses to delete" do
      tx = PiggyBank::Tx.first
      params = update_params tx
      params["_token"] = "bad penny"
      response = delete "/tx/#{tx.tx_id}", params
      expect(response.status).to eq 403
      expect(response.body).to have_tag "h1", text: "Delete Transaction?"
      expect(response.body).to have_tag "div#flash"
      expect(response.body).to have_tag "div.flash.danger", text: "Failed to delete, please try again"
    end
  end

  context "DELETE /tx/:id with version mismatch" do
    it "politely refuses to delete" do
      tx = PiggyBank::Tx.first
      params = update_params tx
      params[:version] = "bad version"
      response = delete "/tx/#{tx.tx_id}", params

      expect(response.status).to eq 409
      expect(response.body).to have_tag "h1", text: "Delete Transaction?"
      expect(response.body).to have_tag "div#flash"
      expect(response.body).to have_tag "div.flash.danger", text: "Someone else updated this tx, please re-confirm delete"
    end
  end
end

# ZZZ: pass list of txs

# ZZZ: GET /tx = new tx form
# ZZZ: POST /tx = create tx
# ZZZ: POST /tx CSRF protection

# ZZZ: GET /tx/:id = view tx
# ZZZ: GET /tx/:id?edit = edit tx form
# ZZZ: PUT /tx/:id = update tx
# ZZZ: PUT /tx/:id CSRF prevention
# ZZZ: PUT /tx/:id version mismatch

# ZZZ: GET /tx/:id?delete = confirm delete form
# ZZZ: DELETE /tx/:id = delete tx
# ZZZ: DELETE /tx/:id CSRF prevention
# ZZZ: DELETE /tx/:id version mismatch
