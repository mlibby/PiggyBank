"use strict"

import { html, render as renderHtml } from "../../lib/lit-html/lit-html.js"

const template = (d) => html`
  <td>${d.description}</td>
  <td>${d.value}</td>
  <td>
    <button class='create btn btn-sm btn-icon btn-outline-secondary'><span class='icon-pencil'></span><span
        class='sr-only'>Edit</span></button>
    <button class='delete btn btn-sm btn-icon btn-outline-danger'><span class='icon-trash'></span><span
        class='sr-only'>Delete</span></button>
  </td>
`

export class ApiKeyView extends Backbone.View {
  preinitialize(args) {
    this.tagName = "tr"
    this.className = "display"
  }

  edit(e) {
    e.preventDefault()
    this.trigger("apiKey:edit", this.model)
  }

  delete(e) {
    e.preventDefault()
    this.trigger("apiKey:delete", this.model)
  }

  render() {
    renderHtml(template({
      id: this.model.get("id"),
      description: this.model.get("description"),
      value: this.model.get("value")
    }), this.el)

    this.$(".btn.edit").on("click", this.edit)
    this.$(".btn.delete").on("click", this.delete)

    return this
  }
}