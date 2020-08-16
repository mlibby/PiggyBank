import "../../__tests__/testHelpers"
import { AccountIndexView } from "../AccountIndexView"

let view
beforeEach(() => {
  view = new AccountIndexView()
  view.listView = {
    on: jest.fn(),
    render: jest.fn().mockReturnValue("list view")
  }
})

test("AccountView has render method", () => {
  const renderedView = view.render()
  expect(view).toBe(renderedView)
  expect(view.el).toMatchSnapshot()
})