import { html, render as renderHtml } from "../../../lib/lit-html/lit-html.js"
import { SettingsIndexView } from "../SettingsIndexView"

let view
beforeEach(() => {
  view = new SettingsIndexView()
})

test("SettingsIndexView has render method", () => {
  const renderedView = view.render()
  expect(view).toBe(renderedView)
  expect(view.el).toMatchSnapshot()
})