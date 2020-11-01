"use strict"

export class CommodityModel extends Backbone.Model {
  preinitialize(args) {
    this.urlRoot = "/api/commodity"

    this.defaults = {
      name: "",
      type: 0,
      symbol: "",
      description: "",
      ticker: ""
    }
  }
}