"use strict"

import { html, render as renderHtml } from "../../lib/lit-html/lit-html.js"

const template = (d) => html`
  <div class='row'>
    <div class='col'>
      <h1>Mortgage Amortization</h1>
      <p>Enter some values, click the button, get a chart</p>
    </div>
  </div>
`

export class MortgageAmortizationView extends Backbone.View {
  render() {
    renderHtml(template(), this.el)
    return this
  }
}
