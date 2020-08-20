"use strict"

import { PiggyBankRouter } from "./PiggyBankRouter.js"
import { AccountCollection } from "./account/AccountCollection.js"
import { CommodityCollection } from "./commodity/CommodityCollection.js"

window.piggybank = {}

$().ready(function () {
  $(window.document).on("click", "a[href]:not([data-bypass])", function (e) {
    var href = { prop: $(this).prop("href"), attr: $(this).attr("href") }
    var root = window.location.protocol + "//" + window.location.host + "/"

    if (href.prop.slice(0, root.length) === root) {
      e.preventDefault()
      Backbone.history.navigate(href.attr, true)
    }

    $(".navbar-collapse").removeClass("show")
  })

  piggybank.accounts = new AccountCollection()
  piggybank.commodities = new CommodityCollection()

  piggybank.accounts.fetch({
    success: () => {
      piggybank.accounts.unflatten()
      piggybank.commodities.fetch({
        success: () => {
          const router = new PiggyBankRouter()
          Backbone.history.start({ pushState: true })
        }
      })
    }
  })
})