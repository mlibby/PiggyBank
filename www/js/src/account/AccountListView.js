"use strict"

import { AccountView } from "./AccountView.js"

export class AccountListView extends Backbone.View {
  constructor(args) {
    super(args)
  }

  preinitialize() {
    this.tagName = "ul"
    this.className = "accounts"
  }

  edit(model) {
    this.trigger("account:edit", model)
  }

  create(model) {
    this.trigger("account:create", model)
  }

  delete(model) {
    this.trigger("account:delete", model)
  }

  render() {
    for (const model of this.collection) {
      const view = new AccountView({ model })
      this.$el.append(view.render().el)
      this.listenTo(view, "account:edit", this.edit)
      this.listenTo(view, "account:create", this.create)
      this.listenTo(view, "account:delete", this.delete)
    }

    return this
  }
}
