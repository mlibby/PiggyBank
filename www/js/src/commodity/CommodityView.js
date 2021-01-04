"use strict"

import { html, render as renderHtml } from "../../lib/lit-html/lit-html.js"

const template = (d) => html`
  <td>${d.name}</td>
  <td>${d.description}</td>
  <td>${d.type}</td>
  <td>${d.ticker}</td>
  <td>${d.fraction}</td>
  <td>
    <button class='create btn btn-sm btn-icon btn-outline-secondary'><span class='icon-pencil'></span><span
        class='sr-only'>Edit</span></button>
    <button class='delete btn btn-sm btn-icon btn-outline-danger'><span class='icon-trash'></span><span
        class='sr-only'>Delete</span></button>
  </td>
`

export class CommodityView extends Backbone.View {
  preinitialize(args) {
    this.tagName = "tr"
  }

  edit(model, e) {
    if (e) {
      e.preventDefault()
    }
    this.trigger("commodity:edit", model)
  }

  render() {
    const data = {
      id: this.model.get("id"),
      name: this.model.get("name"),
      description: this.model.get("description"),
      type: this.model.typeString(),
      ticker: this.model.get("ticker"),
      fraction: this.model.fractionString()
    }
    renderHtml(template(data), this.el)

    this.$(".btn.edit").on("click", (e) => this.edit(this.model, e))
    this.$(".btn.delete").on("click", (e) => this.delete(this.model, e))

    return this
  }
}