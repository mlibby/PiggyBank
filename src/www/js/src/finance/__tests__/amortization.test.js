"use strict"

import { Amortization } from "../amortization"

test("Amortization calculates payment amount", () => {
  const amort = new Amortization(10000000, 0.06/12, 360)
  expect(amort.paymentAmount).toBe(59955)
})

test("Amortization calculates payment schedule", () => {
  const amort = new Amortization(10000000, 0.06/12, 360)
  expect(amort.payments.length).toBe(360)

  //final payment is a "balloon" payment with extra principal
  expect(amort.payments[359].paymentAmount).toBe(60000)
})