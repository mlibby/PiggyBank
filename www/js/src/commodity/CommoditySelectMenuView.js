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
    label = label || "Commodity";
    render(template({ label }), this.el);

    if (this.commodityCollection) {
      this.AddCommodityOptions(this.commodityCollection, commodityId);
    }
    else {
      this.commodityCollection = new CommodityCollection();
      this.commodityCollection.fetch({
        success: (collection, resp, opts) => {
          collection.sort()
          this.AddCommodityOptions(collection, commodityId)
        },
        error: (collection, resp, opts) => {
          alert("Error fetching commodity data")
        }
      })
    }

    return this;
  }

  AddCommodityOptions(collection, commodityId) {
    const commoditySelect = this.$(".select-commodity-id");
    for (let model of collection.models) {
      const option = `<option value='${model.get("commodityId")}'>${model.get("name")}</option>`;
      commoditySelect.append(option);
    }

    commoditySelect.val(commodityId);
    commoditySelect.on('change', (e) => this.trigger('change', e));
  }
}
