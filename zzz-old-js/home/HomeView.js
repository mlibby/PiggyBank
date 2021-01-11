"use strict"

import { html, render as renderHtml } from "../../lib/lit-html/lit-html.js"

const template = (d) => html`
  <div class='row'>
    <div class='col'>
      <h1>Oink! Oink!</h1>
      <p>
        Welcome to PiggyBank.
      </p>
      <p>
        This is a personal finance app. It is free software and the
        source code is at <a href="https://github.com/mlibby/PiggyBank">GitHub</a>.
      </p>
      <p>
        PiggyBank is still in EARLY ALPHA development phase and is not
        ready for end-users! The developer isn't even using it, except
        to test it with test data.
      </p>
      <p>
        Documentation of PiggyBank is available at <a href="https://piggybank.live">piggybank.live</a>
      </p>
      <p>
        A proof-of-concept demo is available at <a href="https://piggybanklive.herokuapp.com">PiggyBank@Heroku</a>
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
