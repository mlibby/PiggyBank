"use strict"

export class CommodityModel extends Backbone.Model {
  preinitialize(args) {
    this.urlRoot = "/api/commodity"

    this.defaults = {
      name: "",
      type: 0,
      symbol: "",
      description: "",
      ticker: "",
      fraction: 100,
      locale: "en-US"
    }
  }

  toString(amount) {
    if (this.get("type") === 1) {
      return (amount / this.get("fraction")).toLocaleString("en-US", { style: 'currency', currency: 'USD' })
    }
    else {
      return `${this.get("name")}${(amount / this.get("fraction")).toFixed(4)}`
    }
  }
}