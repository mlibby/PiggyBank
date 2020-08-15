"use strict"

import { html, render } from "../../lib/lit-html/lit-html.js"
import { getUuid } from "../PiggyBankUtil.js"
import { CommodityCollection } from "./CommodityCollection.js"

const template = (d) => {
  d.uuid = getUuid()
  return html`
    <label for='selectCommodityId-${d.uuid}'>${d.label}</label>
    <select id='selectCommodityId-${d.uuid}' class='select-commodity-id form-control'>
      <option value=''>[Choose Commodity]</option>
    </select>
`;
};

export class CommoditySelectMenuView extends Backbone.View {
  constructor(commodityCollection) {
    super();
    this.commodityCollection = commodityCollection;
  }

  render(commodityId, label) {
    label = label || "Commodity"
    render(template({ label }), this.el)
    this.AddCommodityOptions(this.commodityCollection, commodityId)
    return this
  }

  AddCommodityOptions(collection, commodityId) {
    const commoditySelect = this.$(".select-commodity-id")
    for (let model of piggybank.commodities.models) {
      const option = `<option value='${model.get("id")}'>${model.get("name")}</option>`
      commoditySelect.append(option)
    }

    commoditySelect.val(commodityId)
    commoditySelect.on('change', (e) => this.trigger('change', e))
  }
}
