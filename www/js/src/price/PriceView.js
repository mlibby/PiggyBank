"use strict"

import { html, render } from "../../lib/lit-html/lit-html.js"

const template = (d) => html`
<td>${d.date.toDateString()}</td>
<td>${d.commodityName}</td>
<td>${d.value}</td>
<td>
  <button class="create btn btn-sm btn-icon btn-outline-secondary"><span class="icon-pencil"></span><span class="sr-only">Edit</span></button>
  <button class="delete btn btn-sm btn-icon btn-outline-danger"><span class="icon-trash"></span><span class="sr-only">Delete</span></button>
</td>
`

export class PriceView extends Backbone.View {
  preinitialize(model) {
    this.model = model
    
    this.tagName = "tr"
    this.className = "display"
  }

  edit(model, e) {
    if (e) {
      e.preventDefault()
    }
    this.trigger("price:edit", model)
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
      date: new Date(this.model.get("quoteDate")),
      commodityName: this.model.get("commodityName"),
      value: this.model.get("value")
    }), this.el)

    this.$(".btn.edit").click((e) => this.edit(this.model, e))
    this.$(".btn.create").click((e) => this.create(this.model, e))
    this.$(".btn.delete").click((e) => this.delete(this.model, e))

    return this
  }
}