"use strict";

import { html, render } from "../../lib/lit-html/lit-html.js"
import { AccountCollection } from "./AccountCollection.js"
import { AccountSelectMenuView } from "./AccountSelectMenuView.js"
import { CommoditySelectMenuView } from "../commodity/CommoditySelectMenuView.js";

const template = (d) => html`
<div class="modal fade" id="modalForm" tabindex="-1" role="dialog" aria-hidden="true">
  <div class="modal-dialog modal-xl modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-body">
        <form class="account-editor form">
          <input id="accountId" type="hidden" value="${d.accountId || ''}" />
          <div class="form-row">
            <div class="form-group col">
              <div id="parentSelect"></div>
            </div>
          </div>
          <div class="form-row">
            <div class="form-group col">
              <div id="commoditySelect"></div>
            </div>
          </div>
          <div class="form-row">
            <div class="form-group col">
              <label for="accountName">Name</label>
              <input id="accountName" class="mr-3 form-control" type="text" value="${d.name || ''}" />
            </div>
          </div>
          <div class="form-row">
            <div class="form-group form-check">
              <div class="col">
                <input id="isPlaceholder" class="form-check-input mr-1" type="checkbox" ?checked=${d.isPlaceholder} />
                <label for="isPlaceholder" class="mr-3">
                  Is Placeholder
                </label>
              </div>
            </div>
          </div>
          <div class="form-row">
            <div class="form-group">
              <button class="save btn btn-success mr-2"><span class="icon-solid-check"></span></button>
              <button class="cancel btn btn-danger"><span class="icon-close"></span></button>
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

    this.events = {
      "click .btn.save": "save",
      "click .btn.cancel": "cancel"
    };
  }

  save(e) {
    e.preventDefault()

    const accountId = this.$("#accountId").val()
    this.model.set({
      "accountId": accountId ? Number(accountId) : null,
      "currencyId": this.$("#commoditySelect select.select-commodity-id").find(":selected").val(),
      "name": this.$("#accountName").val(),
      "isPlaceholder": this.$("#isPlaceholder")[0].checked ? 1 : 0,
      "parentId": this.$("#parentSelect select.select-account-id").find(":selected").val()
    })

    this.model.save({}, {
      success: () => {
        if (this.model.children === null) {
          this.model.children = new AccountCollection()
        }
        this.close()
        this.trigger("saved")
      },
      error: () => {
        alert("Error saving account")
      }
    })
  }

  cancel(e) {
    e.preventDefault()
    this.close()
  }

  render() {
    render(template(this.model.attributes), this.el)

    const selectMenu = new AccountSelectMenuView()
    selectMenu.render(this.model.get("parentId"), "Parent Account", true)
    this.$("#parentSelect").html(selectMenu.el)

    const commodityMenu = new CommoditySelectMenuView(this.model.get("commodityCollection"))
    commodityMenu.render(this.model.get("currencyId"), "Currency")
    this.$("#commoditySelect").html(commodityMenu.el)

    return this
  }

  close() {
    this.$("#modalForm").modal("hide")
  }
}
