"use strict"

import { ApiKeyModel } from "./ApiKeyModel.js"

export class ApiKeyCollection extends Backbone.Collection {
  preinitialize() {
    this.model = ApiKeyModel
    this.url = "/api/apiKey"
    this.comparator = "description"
  }
}