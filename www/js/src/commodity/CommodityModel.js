"use strict"

export class CommodityModel extends Backbone.Model {
  preinitialize(args) {
    this.idAttribute = "commodityId"
    this.urlRoot = "/api/commodity"
  }
}