"use strict"

import { html, render } from "../../lib/lit-html/lit-html.js"
import { CommodityCollection } from "./CommodityCollection.js"
import { CommodityFormView } from "./CommodityFormView.js"
import { CommodityModel } from "./CommodityModel.js"
import { CommodityView } from "./CommodityView.js"

const template = (d) => html`
  <div class='row'>
    <div class='col'>
      <h1>Commodities</h1>
      <button id='createCommodity' class='btn btn-primary'>
        <span class='icon-plus'></span> New Commodity
      </button>
      <table class='table mt-3'>
        <tr>
          <th>Name</th>
          <th>Type</th>
          <th>Symbol</th>
          <th>Description</th>
          <th>Ticker</th>
          <th></th>
        </tr>
      </table>
    </div>
  </div>
`

export class CommodityIndexView extends Backbone.View {
  render() {
    render(template(), this.el)

    const commodities = new CommodityCollection()
    commodities.fetch({
      success: (collection, resp, opts) => {
        const $table = this.$el.find("table")
        collection.each(model => {
          const modelView = new CommodityView({ model })
          $table.append(modelView.render().$el)
        })
      }
    })

    this.$("#createCommodity").on("click", e => this.create())

    return this
  }

  create() {
    let commodity = new CommodityModel()
    this.form = new CommodityFormView({model: commodity})
    this.form.on("saved", (e) => {
      this.render()
    })
    $("#formContainer").html(this.form.render().el)
    $("#modalForm .modal-title").text("Create Commodity")
    $("#modalForm").modal("show")
  }
}