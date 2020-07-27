"use strict"

export class TxModel extends Backbone.Model {
  preinitialize() {
    this.urlRoot = "/api/tx"
    this.children = null
  }

  constructor(attr, opts) {
    super(attr, opts)
  }
}