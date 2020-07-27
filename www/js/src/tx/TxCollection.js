"use strict"

import { TxModel } from "./TxModel.js"

export class TxCollection extends Backbone.Collection {
  preinitialize() {
    this.model = TxModel
    this.url = "/api/tx"
    this.comparator = "date"
  }
}