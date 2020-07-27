"use strict"

import { html, render } from "../../lib/lit-html/lit-html.js"
import { CommodityCollection } from "./CommodityCollection.js"
import { CommodityView } from "./CommodityView.js"

const template = (d) => html`
<div class='row'>
  <div class='col'>
    <h1>Commodities</h1>
    <table class='table'>
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
`;

export class CommodityIndexView extends Backbone.View {
  render() {
    render(template(), this.el)

    const commodities = new CommodityCollection()
    commodities.fetch({
      success: (collection, resp, opts) => {
        const $table = this.$el.find("table")
        collection.each(model => {
          const modelView = new CommodityView({ model })
          $table.append(modelView.render().$el);
        })
      }
    })

    return this
  }
}