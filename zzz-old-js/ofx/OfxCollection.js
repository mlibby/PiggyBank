"use strict"

import { OfxModel } from "./OfxModel.js"

export class OfxCollection extends Backbone.Collection {
  preinitialize() {
    this.model = OfxModel
    this.url = "/api/ofx"
  }
}