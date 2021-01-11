"use strict"

import { html, render as renderHtml } from "../../lib/lit-html/lit-html.js";

const template = (d) => html`
  <div class='row'>
    <div class='col'>
      <h1>Budget</h1>
      <p>[TODO: Add Budget Plan Table]</p>
    </div>
  </div>
`

export class BudgetIndexView extends Backbone.View {
  render() {
    renderHtml(template(), this.el)
    return this
  }
}
