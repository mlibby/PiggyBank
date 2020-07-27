"use strict";

import { Router } from "./Router.js";

window.getUuid = function getUuid(a) {
  return a ?
    (a ^ Math.random() * 16 >> a / 4).toString(16) :
    ([1e7] + -1e3 + -4e3 + -8e3 + -1e11).replace(/[018]/g, getUuid);
}

$().ready(function () {
  $(window.document).on("click", "a[href]:not([data-bypass])", function (e) {
    var href = { prop: $(this).prop("href"), attr: $(this).attr("href") };
    var root = window.location.protocol + "//" + window.location.host + "/";

    if (href.prop.slice(0, root.length) === root) {
      e.preventDefault();
      Backbone.history.navigate(href.attr, true);
    }

    $(".navbar-collapse").removeClass("show");
  });

  const router = new Router();
  Backbone.history.start({ pushState: true });
});