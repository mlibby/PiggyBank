"use strict"

import { html, render as renderHtml } from "../../lib/lit-html/lit-html.js"
import { TxCollection } from "./TxCollection.js"
import { TxView } from "./TxView.js"

const template = (d) => html`
  <div class='row'>
    <div class='col'>
      <h1>Transactions</h1>
      <p>[TODO: Add filters for account and date range]</p>
      <table class='table'>
        <tr>
          <th>Date</th>
          <th>Number</th>
          <th>Description</th>
          <th>Account</th>
          <th>Memo</th>
          <th>Amount</th>
        </tr>
      </table>
      <p>[TODO: Add a transaction display]</p>
    </div>
  </div>
`

export class TxIndexView extends Backbone.View {
  render() {
    renderHtml(template(), this.el)

    const txes = new TxCollection()
    txes.fetch({
      success: (collection, resp, opts) => {
        const $table = this.$el.find("table")
        collection.each(model => {
          const modelView = new TxView({ model })
          $table.append(modelView.render().$el)
        })
      }
    })

    return this
  }
}
