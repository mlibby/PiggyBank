"use strict"

import { html, render as renderHtml } from "../../lib/lit-html/lit-html.js"

const template = (d) => html`
  <div class='row'>
    <div class='col'>
      <h1>OFX Import</h1>
      <p>[TODO: build OFX/OFX import function]</p>
    </div>
  </div>
`

export class OfxImportView extends Backbone.View {
  render() {
    renderHtml(template(), this.el)
    return this
  }
}
