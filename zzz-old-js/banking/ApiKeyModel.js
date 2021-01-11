"use strict"

export class ApiKeyModel extends Backbone.Model {
  preinitialize() {
    this.urlRoot = "/api/apiKey"
  }

  constructor(attr, opts) {
    super(attr, opts)
  }
}