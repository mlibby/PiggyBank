"use strict"

import { AccountModel } from "./AccountModel.js"

export class AccountCollection extends Backbone.Collection {
  preinitialize() {
    this.model = AccountModel
    this.url = '/api/account'
    this.comparator = "name"
  }

  unflatten() {
    for (const model of this.models) {
      const parentId = model.get("id")
      const children = this.models.filter(m => m.get("parentId") === parentId)
      if (children.length > 0) {
        model.children = new AccountCollection(children)
        for (const child of children) {
          child.parent = model
        }
      }
    }

    const children = this.models.filter(m => m.get("parentId") !== null)
    for (const m of children) {
      this.remove(m)
    }
  }
}
