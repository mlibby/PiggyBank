"use strict"

import { html, render as renderHtml } from "../../lib/lit-html/lit-html.js"

const template = (d) => html`
  <div class='row'>
    <div class='col'>
      <h1>Mortgage Tools</h1>
      <p>Try the <a href="/mortgage/amort">Amortization Tool</a></p>
    </div>
  </div>
`

export class MortgageIndexView extends Backbone.View {
  render() {
    renderHtml(template(), this.el)
    return this
  }
}
