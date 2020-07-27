"use strict"

import { PriceModel } from "./PriceModel.js"

export class PriceCollection extends Backbone.Collection {
  preinitialize() {
    this.model = PriceModel
    this.url = "/api/price"
    this.comparator = model => model.get("commodityName") + model.get("quoteDate")
  }
}