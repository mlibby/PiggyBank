import { HomeView } from "./HomeView"

test("HomeView has render method", () => {
  const homeView = new HomeView()
  homeView.el.innerHTML = "<div></div>"
  const renderedView = homeView.render()
  expect(homeView).toBe(renderedView)
})