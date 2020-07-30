"use strict"

export class TxModel extends Backbone.Model {
  preinitialize() {
    this.idAttribute = "txId"
    this.urlRoot = "/api/tx"
  }

  constructor(attr, opts) {
    super(attr, opts)
  }
}