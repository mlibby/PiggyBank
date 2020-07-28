import { HomeView } from "./HomeView"

test("HomeView has render method", () => {
  const homeView = new HomeView()
  const renderedView = homeView.render()
  expect(homeView).toBe(renderedView)
  //expect(render.mock).toHaveBeenCalled()
})