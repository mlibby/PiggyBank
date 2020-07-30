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

let app = new Backbone.View()

export function switchView(view, navItem) {
  app.remove()
  $("#app").html(view.render().el)
  $(".nav-item").removeClass("active")
  $(navItem).addClass("active")
}

export class Router extends Backbone.Router {
  preinitialize() {
    this.routes = {
      "": () => switchView(new HomeView(), ""),
      "account": () => switchView(new AccountIndexView(), "#navAccount"),
      "apiKey": () => switchView(new ApiKeyIndexView(), "#navBankingApiKey"),
      // "banking": () => ,
      "budget": () => switchView(new BudgetIndexView(), "#navBudget"),
      "commodity": () => switchView(new CommodityIndexView(), "#navCommodity"),
      "ofx": () => switchView(new OfxIndexView(), "#navBanking"),
      "ofxImport": () => switchView(new OfxImportView(), "#navBankingOfxImport"),
      "price": () => switchView(new PriceIndexView(), "#navPrice"),
      "receipt": () => switchView(new ReceiptIndexView(), "#navReceipt"),
      "report": () => switchView(new ReportIndexView(), "#navReport"),
      "tx": () => switchView(new TxIndexView(), "#navTx"),
    }
  }
}
