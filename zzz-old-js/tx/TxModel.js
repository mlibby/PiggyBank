"use strict"

export class TxModel extends Backbone.Model {
  preinitialize() {
    this.urlRoot = "/api/tx"
  }

  constructor(attr, opts) {
    super(attr, opts)
  }
}