"use strict"

import { html, render } from "../../lib/lit-html/lit-html.js"

const template = (d) => html`
<div class='row'>
  <div class='col'>
    <h1>Reports</h1>
    <p>[tdb]</p>
  </div>
</div>
`

export class ReportIndexView extends Backbone.View {
  render() {
    render(template(), this.el)
    return this
  }
}
