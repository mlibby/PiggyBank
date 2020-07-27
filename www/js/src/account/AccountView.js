"use strict"

import { html, render } from "../../lib/lit-html/lit-html.js"
import { AccountListView } from "./AccountListView.js"

const template = (d) => html`<div class="display">
  <a href="/ledger/${d.accountId}">${d.accountName}</a>
  <button class="edit btn btn-sm btn-icon btn-outline-secondary"><span class="icon-pencil"></span></button>
  <button class="create btn btn-sm btn-icon btn-outline-primary"><span class="icon-plus"></span></button>
  <button class="delete btn btn-sm btn-icon btn-outline-danger"><span class="icon-trash"></span></button>
</div>
`

export class AccountView extends Backbone.View {
  preinitialize(args) {
    this.tagName = "li"
    this.className = ""
    this.subview = null
  }

  edit(model, e) {
    if (e) {
      e.preventDefault()
    }
    this.trigger("account:edit", model)
  }

  create(model, e) {
    if (e) {
      e.preventDefault()
    }
    this.trigger("account:create", model)
  }

  delete(model, e) {
    if (e) {
      e.preventDefault()
    }
    this.trigger("account:delete", model)
  }

  render() {
    render(template({
      accountId: this.model.get("accountId"),
      parentId: this.model.parentId,
      accountName: this.model.get("name"),
      isPlaceholder: this.model.get("isPlaceholder")
    }), this.el)

    if (this.model.get("isPlaceholder")) {
      this.$el.addClass("placeholder")
      this.$el.removeClass("account")
    } else {
      this.$el.addClass("account")
      this.$el.removeClass("placeholder")
    }

    this.$(".btn.edit").click((e) => this.edit(this.model, e))
    this.$(".btn.create").click((e) => this.create(this.model, e))
    this.$(".btn.delete").click((e) => this.delete(this.model, e))

    if (this.model.children) {
      if (this.subview !== null) {
        this.subview.remove()
      }
      this.subview = new AccountListView({ collection: this.model.children })
      this.$el.append(this.subview.render().el)
      this.listenTo(this.subview, "account:edit", this.edit)
      this.listenTo(this.subview, "account:create", this.create)
      this.listenTo(this.subview, "account:delete", this.delete)
    }

    return this
  }
}