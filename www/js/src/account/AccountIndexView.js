"use strict";

import { html, render } from "../../lib/lit-html/lit-html.js"
import { AccountCollection } from "./AccountCollection.js"
import { AccountListView } from "./AccountListView.js"
import { AccountFormView } from "./AccountFormView.js"
import { AccountModel } from "./AccountModel.js"
import { CommodityCollection } from "../commodity/CommodityCollection.js"

const template = (d) => html`
<div class='row'>
  <div class='col'>
    <h1>Accounts</h1>
  </div>
</div>
<div class='row'>
  <div id='formContainer' class='col'>
  </div>
</div>
<div class='row'>
  <div id='tableContainer' class='accounts col'>
  </div>
</div>
`

export class AccountIndexView extends Backbone.View {
  preinitialize(args) {
    this.accountCollection = new AccountCollection()
    this.commodityCollection = new CommodityCollection()
  }

  render() {
    render(template(), this.el)
    this.commodityCollection.fetch({
      success: (collection, resp, opts) => {
        this.accountCollection.fetch({
          success: (collection, resp, opts) => {
            collection.unflatten()
            this.listView = new AccountListView({ collection })
            this.$('#tableContainer').html(this.listView.render().el)
            this.listenTo(this.listView, "account:edit", this.edit)
            this.listenTo(this.listView, "account:create", this.create)
            this.listenTo(this.listView, "account:delete", this.delete)
          }
        })
      }
    })

    return this
  }

  edit(model) {
    this.form = new AccountFormView({
      model,
      commodityCollection: this.commodityCollection
    })
    this.form.on("saved", (e) => {
      this.render()
    })
    this.$("#formContainer").html(this.form.render().el)
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
    this.$("#formContainer").html(this.form.render().el)
    $("#modalForm").modal("show")
  }

  delete(model) {
    model.destroy().then(() => this.render())
  }
}
