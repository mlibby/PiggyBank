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
      const parentId = model.get("accountId")
      const children = this.models.filter(m => m.get("parentId") === parentId)
      if (children.length > 0) {
        model.children = new AccountCollection(children)
        // model.children.on("sync", (e) => {
        //   this.trigger("sync")
        // })
      }
    }

    const children = this.models.filter(m => m.get("parentId") !== null)
    for (const m of children) {
      this.remove(m)
    }
  }

  buildLongNames() {
    for (const model of this.models) {
      let currentModel = model
      let longName = model.get("name")

      while (currentModel.get("parentId") !== null) {
        const parentModel = this.findWhere({ accountId: currentModel.get("parentId") })
        if (parentModel) {
          longName = parentModel.get("name") + " : " + longName
        }
        currentModel = parentModel
      }

      model.set({ longName })
    }
  }
}
