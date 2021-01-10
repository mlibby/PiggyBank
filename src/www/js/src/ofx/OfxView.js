"use strict"

import { html, render as renderHtml } from "../../lib/lit-html/lit-html.js"

const template = (d) => html`
  <td>${d.accountId}</td>
  <td>${d.url}</td>
  <td>${d.user}</td>
  <td>${d.password}</td>
  <td>${d.fid}</td>
  <td>${d.fidOrg}</td>
  <td>${d.bankId}</td>
  <td>${d.acctId}</td>
  <td>${d.acctType}</td>
  <td>
    <button class="edit btn btn-sm btn-icon btn-outline-secondary" data-toggle="modal" data-target="#modalForm">
      <span class="icon-pencil"></span>
    </button>
    <button class="delete btn btn-sm btn-icon btn-outline-danger"><span class="icon-trash"></span></button>
  </td>
`

export class OfxView extends Backbone.View {
  preinitialize(args) {
    this.tagName = "tr"
    this.className = ""

    this.events = {
      "click .btn.edit": "edit",
      "click .btn.delete": "delete"
    }
  }

  edit(e) {
    e.preventDefault()
    this.trigger("ofx:edit", this.model)
  }

  delete(e) {
    e.preventDefault()
    alert("OFX record delete not implemented")
  }

  render() {
    renderHtml(template(this.model.attributes), this.el)
    return this
  }
}