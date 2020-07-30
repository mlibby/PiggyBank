"use strict"

import { html, render } from "../../lib/lit-html/lit-html.js"

const template = (d) => html`
<td>${d.name}</td>
<td>${d.type}</td>
<td>${d.symbol}</td>
<td>${d.description}</td>
<td>${d.ticker}</td>
<td>
  <button class="create btn btn-sm btn-icon btn-outline-secondary"><span class="icon-pencil"></span><span class="sr-only">Edit</span></button>
  <button class="delete btn btn-sm btn-icon btn-outline-danger"><span class="icon-trash"></span><span class="sr-only">Delete</span></button>
</td>
`;

export class CommodityView extends Backbone.View {
  preinitialize(args) {
    this.tagName = "tr"
    this.className = "display"
  }

  edit(model, e) {
    if (e) {
      e.preventDefault()
    }
    this.trigger("commodity:edit", model)
  }

  editCommodity(e) {
    e.preventDefault()

    // const $form = this.$el.find("form").first();

    // $form.find("input[name='id']").val(this.model.get("id"));
    // $form.find("input[name='parentId']").val(this.model.get("parentId"));
    // $form.find("input[name='name']").val(this.model.get("accountName"));
    // if (this.model.get("isPlaceholder") === 1) {
    //   $form.find("input[name='isPlaceholder']").attr("checked", "checked");
    // } else {
    //   $form.find("input[name='isPlaceholder']").removeAttr("checked");
    // }
  }

  render() {
    render(template({
      id: this.model.get("id"),
      name: this.model.get("name"),
      type: this.model.get("type"),
      symbol: this.model.get("symbol"),
      description: this.model.get("description"),
      ticker: this.model.get("ticker")
    }), this.el)

    this.$(".btn.edit").click((e) => this.edit(this.model, e))
    this.$(".btn.create").click((e) => this.create(this.model, e))
    this.$(".btn.delete").click((e) => this.delete(this.model, e))

    return this
  }
}