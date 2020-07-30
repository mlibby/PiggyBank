"use strict"

export class PriceModel extends Backbone.Model {
  preinitialize() {
    this.idAttribute = "priceId"
    this.urlRoot = "/api/price"
  }

  constructor(attr, opts) {
    super(attr, opts)
  }
}