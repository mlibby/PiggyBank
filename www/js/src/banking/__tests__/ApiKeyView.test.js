import "../../__tests__/testHelpers"
import { ApiKeyView } from "../ApiKeyView"

test("ApiKeyView has render method", () => {
  const model = {
    get: jest.fn()
  }
  const view = new ApiKeyView({ model })
  const renderedView = view.render()
  expect(view).toBe(renderedView)
  expect(view.el).toMatchSnapshot()
})