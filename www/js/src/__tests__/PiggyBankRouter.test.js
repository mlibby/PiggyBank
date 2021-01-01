jest.mock("../../lib/lit-html/lit-html.js")

import "../__tests__/testHelpers.js"
import { PiggyBankRouter } from "../PiggyBankRouter"
import { HomeView } from "../home/HomeView.js"
import { AccountIndexView } from "../account/AccountIndexView.js"
import { ApiKeyIndexView } from "../banking/ApiKeyIndexView.js"
import { BudgetIndexView } from "../budget/BudgetIndexView.js"
import { CommodityIndexView } from "../commodity/CommodityIndexView.js"
import { MortgageIndexView } from "../mortgage/MortgageIndexView.js"
import { MortgageAmortizationView } from "../mortgage/MortgageAmortizationView"
import { OfxImportView } from "../banking/OfxImportView.js"
import { OfxIndexView } from "../ofx/OfxIndexView.js"
import { PriceIndexView } from "../price/PriceIndexView.js"
import { ReceiptIndexView } from "../banking/ReceiptIndexView.js"
import { ReportIndexView } from "../report/ReportIndexView.js"
import { TxIndexView } from "../tx/TxIndexView.js"

let router
beforeEach(() => {
  router = new PiggyBankRouter()
  router.switchView = jest.fn()
})

test("PiggyBankRouter.switchView(view, navItem)", () => {
  const renderEl = {
    el: "test el"
  }
  const view = {
    render: jest.fn().mockReturnValue(renderEl)
  }
  const $mocks = {
    html: jest.fn(),
    removeClass: jest.fn(),
    addClass: jest.fn()
  }
  global.$ = jest.fn().mockReturnValue($mocks)
  
  const router2 = new PiggyBankRouter()
  router2.switchView(view, "#idTag")

  //render the view
  expect(view.render).toHaveBeenCalled()
  expect($mocks.html).toHaveBeenCalledWith(renderEl.el)

  //remove the active class from all nav items
  expect(global.$).toHaveBeenCalledWith(".nav-item")
  expect($mocks.removeClass).toHaveBeenCalledWith("active")
  
  //add the active class to the current property
  expect(global.$).toHaveBeenCalledWith("#idTag")
  expect($mocks.addClass).toHaveBeenCalledWith("active")
})

test("route / goes to HomeView", () => {
  router.routes[""].call()
  expect(router.switchView).toHaveBeenCalledWith(expect.any(HomeView), "")
})

test("route /account goes to AccountIndexView", () => {
  router.routes["account"].call()
  expect(router.switchView).toHaveBeenCalledWith(expect.any(AccountIndexView), "#navAccounts")
})

test("route /apiKey goes to ApiKeyIndexView", () => {
  router.routes["apiKey"].call()
  expect(router.switchView).toHaveBeenCalledWith(expect.any(ApiKeyIndexView), "#navBanking")
})

test("route /budget goes to BudgetIndexView", () => {
  router.routes["budget"].call()
  expect(router.switchView).toHaveBeenCalledWith(expect.any(BudgetIndexView), "#navBudget")
})

test("route /commodity goes to CommodityIndexView", () => {
  router.routes["commodity"].call()
  expect(router.switchView).toHaveBeenCalledWith(expect.any(CommodityIndexView), "#navAccounts")
})

test("route /mortgage goes to MortgageIndexView", () => {
  router.routes["mortgage"].call()
  expect(router.switchView).toHaveBeenCalledWith(expect.any(MortgageIndexView), "#navBudget")
})

test("route /mortgage/amort goes to MortgageAmortizationView", () => {
  router.routes["mortgage/amort"].call()
  expect(router.switchView).toHaveBeenCalledWith(expect.any(MortgageAmortizationView), "#navBudget")
})

test("route /ofx goes to OfxIndexView", () => {
  router.routes["ofx"].call()
  expect(router.switchView).toHaveBeenCalledWith(expect.any(OfxIndexView), "#navBanking")
})

test("route /ofxImport goes to OfxImportView", () => {
  router.routes["ofxImport"].call()
  expect(router.switchView).toHaveBeenCalledWith(expect.any(OfxImportView), "#navBanking")
})

test("route /price goes to PriceIndexView", () => {
  router.routes["price"].call()
  expect(router.switchView).toHaveBeenCalledWith(expect.any(PriceIndexView), "#navAccounts")
})

test("route /receipt goes to ReceiptIndexView", () => {
  router.routes["receipt"].call()
  expect(router.switchView).toHaveBeenCalledWith(expect.any(ReceiptIndexView), "#navReceipt")
})

test("route /report goes to ReportIndexView", () => {
  router.routes["report"].call()
  expect(router.switchView).toHaveBeenCalledWith(expect.any(ReportIndexView), "#navReports")
})

test("route /tx goes to TxIndexView", () => {
  router.routes["tx"].call()
  expect(router.switchView).toHaveBeenCalledWith(expect.any(TxIndexView), "#navTx")
})