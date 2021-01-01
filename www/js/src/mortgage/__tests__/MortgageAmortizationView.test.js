import { mockEvent, mock$ } from "../../__tests__/testHelpers"
import { html, render as renderHtml } from "../../../lib/lit-html/lit-html.js"
import { MortgageAmortizationView } from "../MortgageAmortizationView"

let view
beforeEach(() => {
  mockEvent.preventDefault.mockClear()
  view = new MortgageAmortizationView()
})

test("MortgageAmortizationView has render method", () => {
  const renderedView = view.render()
  expect(view).toBe(renderedView)
  expect(view.el).toMatchSnapshot()
})

test("MortgageAmortizationView has calculate button tied to calculate()", () => {
  view.render()
})

test("MortgageAmortizationView.calculate() calculates amortization", () => {
  window.$ = mock$;
  view.render()
  view.calculate(mockEvent)
  expect(mockEvent.preventDefault).toHaveBeenCalled()
})