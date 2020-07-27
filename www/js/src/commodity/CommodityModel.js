"use strict"

export class CommodityModel extends Backbone.Model {
  preinitialize() {
    this.urlRoot = "/api/commodity"
    this.children = null
  }
}