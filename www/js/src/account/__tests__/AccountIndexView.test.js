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
  const modal = jest.fn()
  const text = jest.fn()
  window.$ = jest.fn().mockImplementation(() => {
    return { modal, html, text }
  })

  view.edit(mockAccountAssets)

  expect(html).toHaveBeenCalledWith(view.form.el)
  expect(text).toHaveBeenCalledWith("Edit Account")
  expect(modal).toHaveBeenCalled()
})