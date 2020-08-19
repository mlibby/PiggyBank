"use strict"

import { html, render } from "../../lib/lit-html/lit-html.js"
import { getUuid } from "../PiggyBankUtil.js"

const template = (d) => {
  d.uuid = getUuid()
  return html`
    <label for='selectAccountId-${d.uuid}'>${d.label}</label>
    <select id='selectAccountId-${d.uuid}' class='select-account-id form-control'>
      <option value=''>[Choose Account]</option>
    </select>`
}

export class AccountSelectMenuView extends Backbone.View {
  render(accountId, label, includePlaceholders) {
    label = label || "Account"
    render(template({ label }), this.el)
    this.addAccountOptions(piggybank.accounts, includePlaceholders, accountId)
    return this
  }

  getSelectedId() {
    this.$("select").find(":selected").val()
  }

  addAccountOptions(collection, includePlaceholders, accountId) {
    const accountSelect = this.$(".select-account-id")
    for (const model of collection.models) {
      if (includePlaceholders || model.get("isPlaceholder") === 0) {
        const option = `<option value='${model.get("id")}'>${model.longName()}</option>`
        accountSelect.append(option)
        if (model.children.models?.length > 0) {
          this.addAccountOptions(model.children, includePlaceholders, accountId)
        }
      }
    }

    accountSelect.val(accountId)
    accountSelect.on('change', (e) => this.trigger('change', e))
  }
}
