"use strict"

export class CommodityModel extends Backbone.Model {
  preinitialize() {
    this.idAttribute = "commodityId"
    this.urlRoot = "/api/commodity"
  }
}