"use strict"

export class AccountModel extends Backbone.Model {
  preinitialize() {
    this.urlRoot = "/api/account"
    this.children = []
  }

  longName() {
    let ln = this.get("name")
    let model = this
    while(model.parent) {
      ln = model.parent.get("name") + "::" + ln
      model = model.parent
    }
    return ln
  }
}