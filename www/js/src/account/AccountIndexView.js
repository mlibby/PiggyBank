"use strict"

import { html, render as renderHtml } from "../../lib/lit-html/lit-html.js"
import { AccountListView } from "./AccountListView.js"
import { AccountFormView } from "./AccountFormView.js"
import { AccountModel } from "./AccountModel.js"

const template = (d) => html`
  <div class='row'>
    <div class='col'>
      <h1>Accounts</h1>
    </div>
  </div>
  <div class='row'>
    <div id='tableContainer' class='accounts col'>
    </div>
  </div>
`

export class AccountIndexView extends Backbone.View {
  preinitialize() {
    this.listView = new AccountListView({
      collection: window.piggybank.accounts
    })
  }

  render() {
    renderHtml(template(), this.el)
    this.renderListView()
    return this
  }

  renderListView() {
    this.$("#tableContainer").html(this.listView.render().el)
    this.listenTo(this.listView, "account:edit", this.edit)
    this.listenTo(this.listView, "account:create", this.create)
    this.listenTo(this.listView, "account:delete", this.delete)
  }

  edit(model) {
    this.form = new AccountFormView({ model })
    this.form.on("saved", (e) => {
      this.render()
    })
    $("#formContainer").html(this.form.render().el)
    $("#modalForm .modal-title").text("Edit Account")
    $("#modalForm").modal("show")
  }

  create(parent) {
    const model = new AccountModel({
      parentId: parent.get("id"),
      commodityCollection: this.commodityCollection
    })
    this.form = new AccountFormView({ model })
    this.form.on("saved", (e) => {
      this.render()
    })
    $("#formContainer").html(this.form.render().el)
    $("#modalForm .modal-title").text("Create Account")
    $("#modalForm").modal("show")
  }

  async delete(model) {
    model.destroy().then(() => this.render())
  }
}
