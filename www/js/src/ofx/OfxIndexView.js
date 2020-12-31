"use strict"

import { html, render as renderHtml } from "../../lib/lit-html/lit-html.js"
import { OfxModel } from "./OfxModel.js"
import { OfxCollection } from "./OfxCollection.js"
import { OfxListView } from "./OfxListView.js"
import { OfxFormView } from "./OfxFormView.js"

const template = (d) => html`
  <div class='row'>
    <div class='col'>
      <h1>OFX Configuration</h1>
    </div>
  </div>
  <div class='row'>
    <div id='formContainer' class='col'></div>
  </div>
  <div class='row'>
    <div id='tableContainer' class='col'>
      <div class='spinner-border text-info' role='status'>
        <span class='sr-only'>Loading...</span>
      </div>
    </div>
  </div>
  <div class='row mb-3'>
    <div class='col'>
      <div id='buttonContainer'>
        <button class='create btn btn-success'>
          <span class='icon-plus mr-2'></span>
          <span class='label'>New OFX Account</span>
        </button>
      </div>
    </div>
  </div>
`

export class OfxIndexView extends Backbone.View {
  preinitialize() {
    this.events = {
      "click .btn.create": "create"
    }
  }

  edit(model) {
    this.ofxForm = new OfxFormView({ model })
    this.ofxForm.on({
      "created": (e) => { this.appendCollection(e) }
    })
    this.$("#formContainer").html(this.ofxForm.render().el)
    $("#modalForm").modal("show")
  }

  create(e) {
    e.preventDefault()
    const model = new OfxModel({
      account_id: "",
      url: "",
      user: "",
      password: "",
      fid: "",
      fid_org: "",
      bank_id: "",
      acc_id: "",
      acc_type: ""
    })
    this.ofxForm = new OfxFormView({ model })
    this.ofxForm.on({
      "created": (e) => { this.appendCollection(e) }
    })
    this.$("#formContainer").html(this.ofxForm.render().el)
    $("#modalForm").modal("show")
  }

  appendCollection(model) {
    this.listView.collection.add(model)
    this.listView.render()
  }

  render() {
    renderHtml(template(), this.el)

    const ofxCollection = new OfxCollection()
    ofxCollection.fetch({
      success: (collection, resp, opts) => {
        this.listView = new OfxListView({ collection: collection })
        this.$("#tableContainer").html(this.listView.render().el)
        this.listenTo(this.listView, "ofx:edit", this.edit)
      },
      error: (collection, resp, opts) => {
        alert("Error fetching OFX records")
      }
    })

    return this
  }
}
