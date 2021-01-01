"use strict"

import { html, render as renderHtml } from "../../lib/lit-html/lit-html.js"

const template = (d) => html`
  <div class='row'>
    <div class='col'>
      <h1>Oink! Oink!</h1>
      <p>Welcome to Piggy Bank.</p>
      <p>This is a personal finance app. It is free software and the
        source code is at <a href="https://github.com/mlibby/PiggyBank">GitHub</a>.
      </p>
    </div>
  </div>
`

export class HomeView extends Backbone.View {
  render() {
    renderHtml(template(), this.el)
    return this
  }
}
