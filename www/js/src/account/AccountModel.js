"use strict"

export class AccountModel extends Backbone.Model {
  preinitialize() {
    this.urlRoot = "/api/account"
    this.children = []
  }
}