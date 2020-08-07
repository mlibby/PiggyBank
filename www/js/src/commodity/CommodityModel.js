"use strict"

export class CommodityModel extends Backbone.Model {
  preinitialize(args) {
    this.urlRoot = "/api/commodity"
  }
}