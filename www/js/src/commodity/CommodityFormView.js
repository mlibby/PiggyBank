"use strict";

import { html, render } from "../../lib/lit-html/lit-html.js";

const template = (d) => html`
<div class="modal fade" id="modalForm" tabindex="-1" role="dialog" aria-hidden="true">
  <div class="modal-dialog modal-xl modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-body">
        <form class="commodity-editor form">
          <input id="commodityId" type="hidden" name="id" value="${d.id}" />
          <div class="form-row">
            <div class="form-group col-md-6">
              <label for="name">Name</label>
              <input id="name" class="form-control" type="text" name="name" value="${d.name}" />
            </div>
            <div class="form-group col-md-6">
              <label for="type">Type</label>
              <select id="type" class="form-control">
                <option value="">[Choose Commodity Type]</option>
                <option value="CD">Certificate of Deposit</option>
                <option value="CHECKING">Checking</option>
              </select>
            </div>
            <div class="form-group col-6">
              <label for="user">User</label>
              <input id="user" class="form-control" type="text" name="user" value="${d.user}" />
            </div>
            <div class="form-group col-6">
              <label for="password">Password</label>
              <input id="password" class="form-control" type="text" name="password" value="${d.password}" />
            </div>
          </div>
          <div class="form-row">
            <div class="form-group col-6 col-md-3">
              <label for="fid">FID</label>
              <input id="fid" class="form-control" type="text" name="fid" value="${d.fid}" />
            </div>
            <div class="form-group col-6 col-md-3">
              <label for="fidOrg">FID Org</label>
              <input id="fidOrg" class="form-control" type="text" name="fidOrg" value="${d.fidOrg}" />
            </div>
            <div class="form-group col-6 col-md-3">
              <label for="bankId">Bank ID</label>
              <input id="bankId" class="form-control" type="text" name="bankId" value="${d.bankId}" />
            </div>
            <div class="form-group col-6 col-md-3">
              <label for="acctId">Account ID</label>
              <input id="acctId" class="form-control" type="text" name="acctId" value="${d.acctId}" />
            </div>
            <div class="form-group col-6">
            </div>
            <div class="form-group col-6">
              <label>&nbsp;</label><br />
              <button class="save btn btn-success ml-2"><span class="icon-solid-check"></span></button>
              <button class="cancel btn btn-danger ml-2"><span class="icon-close"></span></button>
            </div>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>
`;

export class CommodityFormView extends Backbone.View {
  preinitialize(args) {
    this.tagName = "div";
    this.className = "";

    this.events = {
      "click .btn.save": "save",
      "click .btn.cancel": "cancel"
    };
  }

  save(e) {
    e.preventDefault();

    this.model.set({
      accountId: this.$(".select-account-id").val(),
      url: this.$("#url").val(),
      user: this.$("#user").val(),
      password: this.$("#password").val(),
      fid: this.$("#fid").val(),
      fidOrg: this.$("#fidOrg").val(),
      bankId: this.$("#bankId").val(),
      acctId: this.$("#acctId").val(),
      acctType: this.$("#acctType").val()
    });

    const isNew = this.model.isNew();
    this.model.save({}, {
      success: (model) => {
        model.attributes.password = "******";
        const acctId = model.attributes.acctId;
        model.attributes.acctId = "****" + acctId.substring(acctId.length - 4);
        if (isNew) {
          this.trigger("created", model);
        } else {
          this.trigger("saved", model);
        }
        this.$("#modalForm").modal("hide");
        this.trigger("closed");
      },
      error: () => {
        alert("Error saving OFX");
      }
    });
  }

  cancel(e) {
    e.preventDefault();
    this.$("#modalForm").modal("hide");
    this.trigger("closed");
  }

  render() {
    render(template(this.model.attributes), this.el);
    return this;
  }
}