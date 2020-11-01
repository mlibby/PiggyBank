"use strict"

import { html, render } from "../../lib/lit-html/lit-html.js"
import { AccountCollection } from "./AccountCollection.js"
import { AccountSelectMenuView } from "./AccountSelectMenuView.js"
import { CommoditySelectMenuView } from "../commodity/CommoditySelectMenuView.js"

const template = (d) => html`
  <div class='modal fade' id='modalForm' tabindex='-1' role='dialog' aria-hidden='true'>
    <div class='modal-dialog modal-xl modal-dialog-centered' role='document'>
      <div class='modal-content'>
        <div class='modal-header'>
          <h3 class='modal-title'>Title</h3>
        </div>
        <form class='account-editor form'>
          <div class='modal-body'>
            <div class='form-row'>
              <div class='form-group col'>
                <div id='parentSelect'></div>
              </div>
            </div>
            <div class='form-row'>
              <div class='form-group col'>
                <div id='commoditySelect'></div>
              </div>
            </div>
            <div class='form-row'>
              <div class='form-group col'>
                <label for='accountName'>Name</label>
                <input id='accountName' class='mr-3 form-control' type='text' value='${d.name}' />
              </div>
            </div>
            <div class='form-row'>
              <div class='form-group col'>
                <div class='form-check'>
                  <input id='isPlaceholder' class='form-check-input' type='checkbox' ?checked=${d.isPlaceholder} />
                  <label for='isPlaceholder' class='form-check-label'>
                    Is Placeholder
                  </label>
                </div>
              </div>
            </div>
          </div>
          <div class='modal-footer'>
            <div class='form-row'>
              <div class='form-group'>
                <button class='save btn btn-success mr-2'><span class='icon-solid-check'></span> Save</button>
                <button class='cancel btn btn-danger'><span class='icon-close'></span> Cancel</button>
              </div>
            </div>
          </div>
        </form>
      </div>
    </div>
  </div>
  </div>
`;

export class AccountFormView extends Backbone.View {
  preinitialize(args) {
    this.tagName = "div"
    this.className = ""

    this.parentMenu = null
    this.commodityMenu = null

    this.events = {
      "click .btn.save": "save",
      "click .btn.cancel": "cancel"
    }
  }

  save(e) {
    e.preventDefault()

    this.model.set({
      "currencyId": this.commodityMenu.getSelectedId(),
      "name": this.$("#accountName").val(),
      "isPlaceholder": this.$("#isPlaceholder")[0].checked,
      "parentId": this.parentMenu.getSelectedId()
    })

    this.model.save({}, {
      success: this.saved,
      error: this.saveError
    })
  }

  saveError() {
    alert("error saving account")
  }

  saved() {
    if (this.model.children === null) {
      this.model.children = new AccountCollection()
    }
    this.close()
    this.trigger("saved")
  }

  cancel(e) {
    e.preventDefault()
    this.close()
  }

  render() {
    render(template(this.model.attributes), this.el)

    this.parentMenu = new AccountSelectMenuView()
    this.parentMenu.render(this.model.get("parentId"), "Parent Account", true)
    this.$("#parentSelect").html(this.parentMenu.el)

    this.commodityMenu = new CommoditySelectMenuView(this.model.get("commodityCollection"))
    this.commodityMenu.render(this.model.get("currencyId"), "Currency")
    this.$("#commoditySelect").html(this.commodityMenu.el)

    return this
  }

  close() {
    this.$("#modalForm").modal("hide")
  }
}
