"use strict"

export class OfxModel extends Backbone.Model {
  preinitialize() {
    this.urlRoot = "/api/ofx"
    this.attributes = {
      accountId: null,
      url: "",
      user: "",
      password: "",
      fid: null,
      fidOrg: null,
      bankId: "",
      acctId: "",
      acctType: ""
    }
  }
}