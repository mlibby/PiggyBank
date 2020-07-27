"use strict"

export class PriceModel extends Backbone.Model {
  preinitialize() {
    this.urlRoot = "/api/commodity"
    this.children = null
  }

  constructor(attr, opts) {
    super(attr, opts)
  }
}