"use strict"

import { HomeView } from "./home/HomeView.js"
import { AccountIndexView } from "./account/AccountIndexView.js"
import { ApiKeyIndexView } from "./banking/ApiKeyIndexView.js"
import { BudgetIndexView } from "./budget/BudgetIndexView.js"
import { CommodityIndexView } from "./commodity/CommodityIndexView.js"
import { OfxImportView } from "./banking/OfxImportView.js"
import { OfxIndexView } from "./ofx/OfxIndexView.js"
import { PriceIndexView } from "./price/PriceIndexView.js"
import { ReceiptIndexView } from "./banking/ReceiptsView.js"
import { ReportIndexView } from "./report/ReportIndexView.js"
import { TxIndexView } from "./tx/TxIndexView.js"

export class PiggyBankRouter extends Backbone.Router {
  preinitialize() {
    this.routes = {
      "": () => this.switchView(new HomeView(), ""),
      "account": () => this.switchView(new AccountIndexView(), "#navAccount"),
      "apiKey": () => this.switchView(new ApiKeyIndexView(), "#navBankingApiKey"),
      // "banking": () => ,
      "budget": () => this.switchView(new BudgetIndexView(), "#navBudget"),
      "commodity": () => this.switchView(new CommodityIndexView(), "#navCommodity"),
      "ofx": () => this.switchView(new OfxIndexView(), "#navBanking"),
      "ofxImport": () => this.switchView(new OfxImportView(), "#navBankingOfxImport"),
      "price": () => this.switchView(new PriceIndexView(), "#navPrice"),
      "receipt": () => this.switchView(new ReceiptIndexView(), "#navReceipt"),
      "report": () => this.switchView(new ReportIndexView(), "#navReport"),
      "tx": () => this.switchView(new TxIndexView(), "#navTx"),
    }
  }

  switchView(view, navItem) {
    $("#app").html(view.render().el)
    $(".nav-item").removeClass("active")
    $(navItem).addClass("active")
  }
}
