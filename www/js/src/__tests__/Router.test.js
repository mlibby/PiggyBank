jest.mock("../../lib/lit-html/lit-html.js")

import {Router} from "../Router"

test("new Router()", () => {
  const router = new Router()
  expect(Object.getOwnPropertyNames(router.routes)).toContain("")
})