"use strict"

import { html, render } from "../../lib/lit-html/lit-html.js"
import { ApiKeyCollection } from "./ApiKeyCollection.js"
import { ApiKeyView } from "./ApiKeyView.js"

const template = (d) => html`
  <div class='row'>
    <div class='col'>
      <h1>API Keys</h1>
      <table class='table'>
        <tr>
          <th>Description</th>
          <th>Key Value</th>
          <th></th>
        </tr>
      </table>
    </div>
  </div>
`

export class ApiKeyIndexView extends Backbone.View {
  render() {
    render(template(), this.el)

    const apiKeys = new ApiKeyCollection()
    apiKeys.fetch({
      success: this.fetchSuccess.bind(this)
    })

    return this
  }

  fetchSuccess(collection, resp, opts) {
    const $table = this.$el.find("table")
    collection.each(model => {
      const modelView = new ApiKeyView({ model })
      $table.append(modelView.render().$el);
    })
  }
}