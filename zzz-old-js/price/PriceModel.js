"use strict"

export class PriceModel extends Backbone.Model {
  preinitialize() {
    this.urlRoot = "/api/price"
  }
}