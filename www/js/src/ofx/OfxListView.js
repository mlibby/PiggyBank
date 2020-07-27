"use strict";

import { html, render } from "../../lib/lit-html/lit-html.js";
import { OfxView } from "./OfxView.js";

const template = (d) => html`
<tr>
  <th>Account</th>
  <th>URL</th>
  <th>User</th>
  <th>Password</th>
  <th>FID</th>
  <th>FID Org</th>
  <th>Bank ID</th>
  <th>Account ID</th>
  <th>Account Type</th>
  <th></th>
</tr>
`;

export class OfxListView extends Backbone.View {
  preinitialize() {
    this.tagName = "table";
    this.className = "table";
  }

  render() {
    this.$el.html("");
    render(template(), this.el);
    for (const model of this.collection) {
      const view = new OfxView({ model });
      this.$el.append(view.render().el);
      this.listenTo(view, "ofx:edit", this.edit);
    }

    return this;
  }

  edit(model) {
    console.log("Edit model " + model.id);
    this.trigger("ofx:edit", model);
  }
}

