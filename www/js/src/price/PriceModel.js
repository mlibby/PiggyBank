"use strict"

export class PriceModel extends Backbone.Model {
  preinitialize() {
    this.urlRoot = "/api/price"
  }

  constructor(attr, opts) {
    super(attr, opts)
  }
}