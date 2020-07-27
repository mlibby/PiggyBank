"use strict"

export class ApiKeyModel extends Backbone.Model {
  preinitialize() {
    this.urlRoot = "/api/apiKey"
    this.children = null
  }

  constructor(attr, opts) {
    super(attr, opts)
  }
}