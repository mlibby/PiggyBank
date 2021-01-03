"use strict"

import { html, render as renderHtml } from "../../lib/lit-html/lit-html.js"

const template = (d) => html`
  <div class='row'>
    <div class='col'>
      <h1>Settings</h1>
      <p>[TODO: allow choosing default currency]</p>
      <p>[TODO: allow editing locale]</p>
    </div>
  </div>
`

export class SettingsIndexView extends Backbone.View {
  render() {
    renderHtml(template(), this.el)
    return this
  }
}