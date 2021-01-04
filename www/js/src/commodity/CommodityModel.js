"use strict"

const types = [
  'Currency',
  'Investment'
]

export class CommodityModel extends Backbone.Model {
  preinitialize(args) {
    this.urlRoot = "/api/commodity"

    this.defaults = {
      name: "",
      description: "",
      type: 0,
      ticker: "",
      fraction: 100
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

  fractionString() {
    const fraction = Number(this.get("fraction"))
    if(fraction === 1) {
      return "1"
    }
    else {
      return "1/" + fraction.toLocaleString(piggybank.settings.locale)
    }
  }

  typeString() {
    const type = Number(this.get("type")) - 1
    return types[type]
  }
}