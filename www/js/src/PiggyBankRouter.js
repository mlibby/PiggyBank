"use strict"

import { HomeView } from "./home/HomeView.js"
import { AccountIndexView } from "./account/AccountIndexView.js"
import { ApiKeyIndexView } from "./banking/ApiKeyIndexView.js"
import { BudgetIndexView } from "./budget/BudgetIndexView.js"
import { CommodityIndexView } from "./commodity/CommodityIndexView.js"
import { MortgageAmortizationView } from "./mortgage/MortgageAmortizationView.js"
import { MortgageIndexView } from "./mortgage/MortgageIndexView.js"
import { OfxImportView } from "./banking/OfxImportView.js"
import { OfxIndexView } from "./ofx/OfxIndexView.js"
import { PriceIndexView } from "./price/PriceIndexView.js"
import { ReceiptIndexView } from "./banking/ReceiptIndexView.js"
import { ReportIndexView } from "./report/ReportIndexView.js"
import { SettingsIndexView } from "./settings/SettingsIndexView.js"
import { TxIndexView } from "./tx/TxIndexView.js"

export class PiggyBankRouter extends Backbone.Router {
  preinitialize() {
    this.routes = {
      "": () => this.switchView(new HomeView(), ""),
      "account": () => this.switchView(new AccountIndexView(), "#navAccounts"),
      "apiKey": () => this.switchView(new ApiKeyIndexView(), "#navBanking"),
      // "banking": () => ,
      "budget": () => this.switchView(new BudgetIndexView(), "#navBudget"),
      "commodity": () => this.switchView(new CommodityIndexView(), "#navAccounts"),
      "mortgage": () => this.switchView(new MortgageIndexView(), "#navBudget"),
      "mortgage/amort": () => this.switchView(new MortgageAmortizationView(), "#navBudget"),
      "ofx": () => this.switchView(new OfxIndexView(), "#navBanking"),
      "ofxImport": () => this.switchView(new OfxImportView(), "#navBanking"),
      "price": () => this.switchView(new PriceIndexView(), "#navAccounts"),
      "receipt": () => this.switchView(new ReceiptIndexView(), "#navReceipt"),
      "report": () => this.switchView(new ReportIndexView(), "#navReports"),
      "settings": () => this.switchView(new SettingsIndexView(), "#navSettings"),
      "tx": () => this.switchView(new TxIndexView(), "#navTx"),
    }
  }

  switchView(view, navItem) {
    $("#app").html(view.render().el)
    $(".nav-item").removeClass("active")
    $(navItem).addClass("active")
  }
}
