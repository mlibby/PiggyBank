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

test("view.edit rerenders the view when the saved event is triggered", () => {
  const html = jest.fn()
  const modal = jest.fn()
  const text = jest.fn()
  window.$ = jest.fn().mockImplementation(() => {
    return { modal, html, text }
  })

  view.render = jest.fn()
  view.edit(mockAccountAssets)
  view.form.trigger("account:saved")

  expect(view.render).toHaveBeenCalled()
})

test("view.creates displays an AccountForm with a default AccountModel", () => {
  const html = jest.fn()
  const modal = jest.fn()
  const text = jest.fn()
  window.$ = jest.fn().mockImplementation(() => {
    return { modal, html, text }
  })
  const hide = jest.fn()
  view.$ = jest.fn().mockReturnValue({ hide })

  view.create(mockAccountAssets)

  expect(html).toHaveBeenCalledWith(view.form.el)
  expect(text).toHaveBeenCalledWith("Create Account")
  expect(modal).toHaveBeenCalled()
})

test("view.create renders itself when the saved event is triggered", () => {
  const html = jest.fn()
  const modal = jest.fn()
  const text = jest.fn()
  window.$ = jest.fn().mockImplementation(() => {
    return { modal, html, text }
  })

  view.render = jest.fn()
  view.create(mockAccountAssets)
  view.form.trigger("account:saved")

  expect(view.render).toHaveBeenCalled()
})

test("view.delete calls model.destroy then renders itself", () => {
  mockAccountAssets.destroy = jest.fn().mockResolvedValue("promises")
  view.render = jest.fn()

  expect.assertions(2)
  view.delete(mockAccountAssets).then(() => {
    expect(mockAccountAssets.destroy).toHaveBeenCalled()
    expect(view.render).toHaveBeenCalled()
  })
})