require_relative "../spec_helper.rb"

describe PiggyBank::App do
  include Rack::Test::Methods

  let(:app) { PiggyBank::App.new }

  context "GET /report" do
    it "has a list of reports" do
      response = get "/report"
      expect(response.status).to eq 200
      expect(response.body).to have_tag "h1", text: "Reports"
    end
  end

  context "GET /report/balance" do
    it "has a balance sheet" do
      response = get "/report/balance"
      expect(response.status).to eq 200
      expect(response.body).to have_tag "h1", text: "Balance Sheet"
    end
  end

  context "GET /report/income" do
    it "has an income statement" do
      response = get "/report/income"
      expect(response.status).to eq 200
      expect(response.body).to have_tag "h1", text: "Income Statement"
    end
  end

  context "GET /report/cash" do
    it "has a cash flow report" do
      response = get "/report/cash"
      expect(response.status).to eq 200
      expect(response.body).to have_tag "h1", text: "Cash Flow"
    end
  end
end

# ZZZ: GET /report/balance
# ZZZ: GET /report/income
# ZZZ: GET /report/cash
