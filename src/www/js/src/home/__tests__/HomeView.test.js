jest.mock("../../../lib/lit-html/lit-html.js", () => {
  return {
    html: jest.fn().mockImplementation(() => {
      return "htmlTemplate"
    }),
    render: jest.fn().mockImplementation(() => {
      return "renderedHtml"
    })
  }
})

import { html, render } from "../../../lib/lit-html/lit-html.js"
import { HomeView } from "../HomeView"

test("HomeView has render method", () => {
  const homeView = new HomeView()
  const renderedView = homeView.render()
  expect(homeView).toBe(renderedView)
  expect(html).toMatchSnapshot()
  expect(render).toHaveBeenCalledWith("htmlTemplate", homeView.el)
})