import { mockAccountAssets } from "../../__tests__/testHelpers"
import { AccountIndexView } from "../AccountIndexView"

let view
beforeEach(() => {
  view = new AccountIndexView()
  view.listView = {
    on: jest.fn(),
    render: jest.fn().mockReturnValue("list view")
  }
})

test("AccountIndexView has render method", () => {
  const renderedView = view.render()
  expect(view).toBe(renderedView)
  expect(view.el).toMatchSnapshot()
})

test("view.edit creates an AccountForm and displays it", () => {
  const html = jest.fn()
  view.$el = {
    find: jest.fn().mockReturnValue({ html })
  }
  const modal = jest.fn()
  window.$ = jest.fn().mockImplementation(() => {
    return { modal }
  })

  view.edit(mockAccountAssets)

  expect(view.$el.find).toHaveBeenCalledWith("#formContainer")
  expect(html).toHaveBeenCalledWith(view.form.el)
  expect(modal).toHaveBeenCalled()
})