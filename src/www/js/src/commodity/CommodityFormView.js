"use strict"

import { html, render as renderHtml } from "../../lib/lit-html/lit-html.js"

const template = (d) => html`
  <div class='modal fade' id='modalForm' tabindex='-1' role='dialog' aria-hidden='true'>
    <div class='modal-dialog modal-xl modal-dialog-centered' role='document'>
      <div class='modal-content'>
        <div class='modal-header'>
          <h3 class='modal-title'>Commodity</h3>
        </div>
        <form class='commodity-editor form'>
          <div class='modal-body'>
            <input id='commodityId' type='hidden' name='id' value='${d.id}' />
            <div class='form-row'>
              <div class='form-group col'>
                <label for='name'>Name</label>
                <input id='name' class='form-control' type='text' name='name' value='${d.name}' />
              </div>
              <div class='form-group col'>
                <label for='type'>Type</label>
                <select id='type' class='form-control'>
                  <option value=''>[Choose Commodity Type]</option>
                  <option value='1'>Currency</option>
                  <option value='2'>Investment</option>
                </select>
              </div>
            </div>
            <div class='form-row'>
              <div class='form-group col'>
                <label for='description'>Description</label>
                <input id='description' class='form-control' type='text' name='description' value='${d.description}' />
              </div>
            </div>
            <div class='form-row'>
              <div class='form-group col'>
                <label for='ticker'>Ticker</label>
                <input id='ticker' class='form-control' type='text' name='ticker' value='${d.ticker}' />
              </div>
              <div class='form-group col'>
                <label for='fraction'>Fraction</label>
                <select id='fraction' class='form-control'>
                  <option>[Choose Fraction]</option>
                  <option value='1'>Whole Values (123)</option>
                  <option value='10'>1/10 (123.4)</option>
                  <option value='100'>1/100 (123.45)</option>
                  <option value='1000'>1/1,000 (123.456)</option>
                  <option value='10000'>1/10,000 (123.4567)</option>
                </select>
              </div>
            </div>
          </div>
          <div class='modal-footer'>
            <div class='form-row'>
              <div class='form-group'>
                <button class='save btn btn-success ml-2'><span class='icon-solid-check'></span> Save</button>
                <button class='cancel btn btn-danger ml-2'><span class='icon-close'></span> Cancel</button>
              </div>
            </div>
          </div>
        </form>
      </div>
    </div>
  </div>
  </div>
`

export class CommodityFormView extends Backbone.View {
  preinitialize(args) {
    this.tagName = "div"
    this.className = ""

    this.events = {
      "click .btn.save": "save",
      "click .btn.cancel": "cancel"
    }
  }

  render() {
    renderHtml(template(this.model.attributes), this.el)
    return this
  }

  save(e) {
    e.preventDefault()

    this.model.set({
      id: this.$("#id").val(),
      name: this.$("#name").val(),
      description: this.$("#description").val(),
      type: this.$("#type").val(),
      ticker: this.$("#ticker").val(),
      fraction: Number(this.$("#fraction").val()),
      version: this.$("#version").val()
    })

    const isNew = this.model.isNew()
    this.model.save({}, {
      success: (model) => { this.saved(isNew, model) },
      error: this.saveError
    })
  }

  saved(isNew, model) {
    this.close()
    if (isNew) {
      this.trigger("saved", model)
    }
    else {
      this.trigger("created", model)
    }
  }

  saveError(model, response, opts) {
    alert("error saving commodity: " + response.responseJSON.message)
  }

  cancel(e) {
    e.preventDefault()
    this.close()
  }

  close() {
    this.$("#modalForm").modal("hide")
  }
}