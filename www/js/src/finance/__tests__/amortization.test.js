"use strict"

import { Amortization } from "../amortization"

test("Amortization calculates payment amount", () => {
  const amort = new Amortization(10000000, 0.06/12, 360)
  expect(amort.payment()).toBe(59955)
})