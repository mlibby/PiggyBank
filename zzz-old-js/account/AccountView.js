"use strict"

import { html, render as renderHtml } from "../../lib/lit-html/lit-html.js"
import { AccountListView } from "./AccountListView.js"

const template = d => html`
  <div class='display'>
    <a href='/ledger/${d.id}'>${d.accountName}</a>
    ${ d.parentId != null ?
      html`<button class='edit btn btn-sm btn-icon btn-outline-secondary'><span class='icon-pencil'></span></button>`
      : "" }
    <button class='create btn btn-sm btn-icon btn-outline-primary'><span class='icon-plus'></span></button>
    ${ d.parentId != null ?
      html`<button class='delete btn btn-sm btn-icon btn-outline-danger'><span class='icon-trash'></span></button>`
      : "" }
  </div>
`

export class AccountView extends Backbone.View {
  preinitialize(args) {
    this.tagName = "li"
    this.className = ""
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
    renderHtml(template({
      id: this.model.get("id"),
      parentId: this.model.get("parentId"),
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

    this.$(".btn.edit").on("click", e => this.edit(this.model, e))
    this.$(".btn.create").on("click", e => this.create(this.model, e))
    this.$(".btn.delete").on("click", e => this.delete(this.model, e))

    if (this.model.children.length > 0) {
      if (this.subview != null) {
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