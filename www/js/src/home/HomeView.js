"use strict";

import { html, render } from "../../lib/lit-html/lit-html.js";

const template = (d) => html`
<div class='row'>
  <div class='col'>
    <h1>Oink! Oink!</h1>
    <p>Welcome to Piggy Bank.</p>
  </div>
</div>
`;

export class HomeView extends Backbone.View {
  render() {
    render(template(), this.el);
    return this;
  }
}
