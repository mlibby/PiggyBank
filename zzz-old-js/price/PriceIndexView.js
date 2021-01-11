"use strict"

import { html, render as renderHtml } from "../../lib/lit-html/lit-html.js"
import { PriceCollection } from "./PriceCollection.js"
import { PriceView } from "./PriceView.js"

const template = (d) => html`
  <div class='row'>
    <div class='col'>
      <h1>Prices</h1>
      <p>[TODO: add price edit form]</p>
      <p>[TODO: add button to fetch prices from external API]</p>
      <table class='table'>
        <tr>
          <th>Date</th>
          <th>Commodity</th>
          <th>Value</th>
          <th></th>
        </tr>
      </table>
    </div>
  </div>
`

export class PriceIndexView extends Backbone.View {
  render() {
    renderHtml(template(), this.el)

    const prices = new PriceCollection()
    prices.fetch({
      success: (collection, resp, opts) => {
        const $table = this.$el.find("table")
        collection.each(model => {
          const modelView = new PriceView({ model })
          $table.append(modelView.render().$el)
        })
      }
    })

    return this
  }
}