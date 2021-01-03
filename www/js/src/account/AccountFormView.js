"use strict"

import { html, render as renderHtml } from "../../lib/lit-html/lit-html.js"
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
              <div class='form-group col-lg-3'>
                <label for='accountType'>Account Type</label>
                <select id='accountType' class='form-control'>
                  <option value="1">Asset</option>
                  <option value="2">Equity</option>
                  <option value="3">Expense</option>
                  <option value="4">Income</option>
                  <option value="5">Liability</option>
                  <option value="6">Mortgage</option>
                </select>
              </div>
              <div class='form-group col-lg-6'>
                <div id='parentSelect'></div>
              </div>
              <div class='form-group col-lg-3'>
                <div id='commoditySelect'></div>
              </div>
            </div>
            <div class='form-row'>
              <div class='form-group col'>
                <label for='accountName'>Name</label>
                <input id='accountName' class='form-control' type='text' value='${d.name}' />
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
          <div id='mortgage-details' class='account-details' style='display: none'>
            <hr />
            <div class='form-row'>
              <h4 class='col'>Mortgage Details</h4>
            </div>
            <div class='form-row'>
              <div class='form-group col'>
                <label for='mortgagePrincipal'>Principal</label>
                <input id='mortgagePrincipal' class='form-control' type='number' value='${d.mortgagePrincipal}' />
              </div>
              <div class='form-group col'>
                <label for='mortgageRate'>Rate</label>
                <input id='mortgageRate' class='form-control' type='number' value='${d.mortgageRate}' />
              </div>
              <div class='form-group col'>
                <label for='mortgageStartDate'>Start Date</label>
                <input id='mortgageStartDate' class='form-control' type='date' value='${d.mortgageStartDate}' />
              </div>
              <div class='form-group col'>
                <label for='mortgagePayments'>Payments</label>
                <input id='mortgagePayments' class='form-control' type='text' value='${d.mortgagePayments}' />
              </div>
              <div class='form-group col'>
                <label for='mortgagePeriod'>Period</label>
                <select id='mortgagePeriod'>
                  <option>Monthly</option>
                </select>
              </div>
            </div>
          </div>
          <div class='modal-footer'>
            <div class='form-group'>
              <button class='save btn btn-success mr-2'><span class='icon-solid-check'></span> Save</button>
              <button class='cancel btn btn-danger'><span class='icon-close'></span> Cancel</button>
            </div>
          </div>
        </form>
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

    const commodityId = this.commodityMenu.getSelectedId()
    const parentId = this.parentMenu.getSelectedId()
    const type = this._getType()
    const typeData = this._getTypeData()

    this.model.set({
      commodityId,
      "name": this.$("#accountName").val(),
      "isPlaceholder": this.$("#isPlaceholder")[0].checked,
      parentId,
      type,
      typeData
    })

    this.model.save({}, {
      success: this.saved.bind(this),
      error: this.saveError.bind(this)
    })
  }

  saveError(model, response, opts) {
    alert("error saving account: " + response.responseJSON.message)
  }

  saved(model, response, opts) {
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
    renderHtml(template(this.model.attributes), this.el)

    this.parentMenu = new AccountSelectMenuView()
    this.parentMenu.render(this.model.get("parentId"), "Parent Account", true)
    this.$("#parentSelect").html(this.parentMenu.el)

    this.commodityMenu = new CommoditySelectMenuView(this.model.get("commodityCollection"))
    this.commodityMenu.render(this.model.get("currencyId"), "Currency")
    this.$("#commoditySelect").html(this.commodityMenu.el)

    this.$("#accountType").on("change", this.showHideDetails.bind(this))

    return this
  }

  showHideDetails() {
    const type = this._getType()
    if (type < 6) {
      this.$(".account-details").hide()
    }
    else if (type === 6) {
      this.$("#mortgage-details").show()
    }
    else {
      throw new Error(`Account type ${type} not supported`)
    }
  }

  close() {
    this.$("#modalForm").modal("hide")
  }

  _getType() {
    return Number(this.$("#accountType").find(":selected").val())
  }

  _getTypeData() {
    const type = this._getType()
    if (type < 6) {
      return "{}"
    }
    else if (type === 6) {
      return this._getMortgageData()
    }
    else {
      throw new Error(`Account type ${type} not supported`)
    }
  }

  _getMortgageData() {
    const data = {
      mortgagePrincipal: this.$("#mortgagePrincipal").val(),
      mortgageRate: this.$("#mortgageRate").val(),
      mortgageStartDate: this.$("#mortgageStartDate").val(),
      mortgagePayments: this.$("#mortgagePayments").val(),
      mortgagePeriod: "monthly"
    }
    return data
  }
}