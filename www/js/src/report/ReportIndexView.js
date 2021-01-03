"use strict"

import { html, render as renderHtml } from "../../lib/lit-html/lit-html.js"

const template = (d) => html`
  <div class='row'>
    <div class='col'>
      <h1>Reports</h1>
      <p>[TODO: Add a Balance Sheet page</p>
      <p>[TODO: Add an Income Statement page]</p>
      <p>[TODO: Add a Cash Flow page]</p>
    </div>
  </div>
`

export class ReportIndexView extends Backbone.View {
  render() {
    renderHtml(template(), this.el)
    return this
  }
}
