"use strict"

import { html, render } from "../../lib/lit-html/lit-html.js"
import { getUuid} from "../PiggyBankUtil.js"
import { AccountCollection } from "./AccountCollection.js"

const template = (d) => {
  d.uuid = getUuid()
  return html`
    <label for='selectAccountId-${d.uuid}'>${d.label}</label>
    <select id='selectAccountId-${d.uuid}' class='select-account-id form-control'>
      <option value=''>[Choose Account]</option>
    </select>`
}

export class AccountSelectMenuView extends Backbone.View {
  constructor(accounts) {
    super()
    this.accounts = accounts
  }

  render(accountId, label, includePlaceholders) {
    label = label || "Account"
    render(template({ label }), this.el)

    if (this.accounts) {
      this.AddAccountOptions(this.accounts.collection, includePlaceholders, accountId)
    }
    else {
      this.accounts = new AccountCollection()
      this.accounts.fetch({
        success: (collection, resp, opts) => {
          collection.buildLongNames()
          collection.comparator = "longName"
          collection.sort()
          this.AddAccountOptions(collection, includePlaceholders, accountId)
        },
        error: (collection, resp, opts) => {
          alert("Error fetching account data")
        }
      })
    }

    return this
  }

  AddAccountOptions(collection, includePlaceholders, accountId) {
    const accountSelect = this.$(".select-account-id")
    for (let model of collection.models) {
      if (includePlaceholders || model.get("isPlaceholder") === 0) {
        const option = `<option value='${model.get("accountId")}'>${model.get("longName")}</option>`
        accountSelect.append(option)
      }
    }

    accountSelect.val(accountId)
    accountSelect.on('change', (e) => this.trigger('change', e))
  }
}
