import { html, render as renderHtml } from "../../../lib/lit-html/lit-html.js"
import { MortgageAmortizationView } from "../MortgageAmortizationView"

let view
beforeEach(() => {
  view = new MortgageAmortizationView()
})

test("MortgageAmortizationView has render method", () => {
  const renderedView = view.render()
  expect(view).toBe(renderedView)
  expect(view.el).toMatchSnapshot()
})