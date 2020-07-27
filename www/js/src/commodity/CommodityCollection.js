"use strict"

import { CommodityModel } from "./CommodityModel.js"

export class CommodityCollection extends Backbone.Collection {
  preinitialize() {
    this.model = CommodityModel
    this.url = '/api/commodity'
    this.comparator = "name"
  }
}