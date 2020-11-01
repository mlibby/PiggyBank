"use strict"

import { html, render } from "../../lib/lit-html/lit-html.js"

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
            </div>
            <div class='form-row'>
              <div class='form-group col'>
                <label for='type'>Type</label>
                <select id='type' class='form-control'>
                  <option value=''>[Choose Commodity Type]</option>
                  <option value='Currency'>Currency</option>
                  <option value='Investment'>Investment</option>
                </select>
              </div>
            </div>
            <div class='form-row'>
              <div class='form-group col'>
                <label for='symbol'>User</label>
                <input id='symbol' class='form-control' type='text' name='symbol' value='${d.symbol}' />
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

  save(e) {
    e.preventDefault()

    this.model.set({
      accountId: this.$(".select-account-id").val(),
      url: this.$("#url").val(),
      user: this.$("#user").val(),
      password: this.$("#password").val(),
      fid: this.$("#fid").val(),
      fidOrg: this.$("#fidOrg").val(),
      bankId: this.$("#bankId").val(),
      bankAccountId: this.$("#acctId").val(),
      bankAccountType: this.$("#acctType").val()
    })

    const isNew = this.model.isNew()
    this.model.save({}, {
      success: (model) => {
        model.attributes.password = "******"
        const acctId = model.attributes.acctId
        model.attributes.accontId = "****" + acctId.substring(accountId.length - 4)
        if (isNew) {
          this.trigger("created", model)
        }
        else {
          this.trigger("saved", model)
        }
        this.$("#modalForm").modal("hide")
        this.trigger("closed")
      },
      error: () => {
        alert("Error saving OFX")
      }
    })
  }

  cancel(e) {
    e.preventDefault()
    this.$("#modalForm").modal("hide")
    this.trigger("closed")
  }

  render() {
    render(template(this.model.attributes), this.el)
    return this
  }
}