import { html, render as renderHtml } from "../../../lib/lit-html/lit-html.js"
import { MortgageIndexView } from "../MortgageIndexView"

let view
beforeEach(() => {
  view = new MortgageIndexView()
})

test("HomeView has render method", () => {
  const renderedView = view.render()
  expect(view).toBe(renderedView)
  expect(view.el).toMatchSnapshot()
})