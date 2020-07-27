"use strict"

export class AccountModel extends Backbone.Model {
  preinitialize() {
    this.idAttribute = "accountId"
    this.urlRoot = "/api/account"
    this.children = []
  }
}