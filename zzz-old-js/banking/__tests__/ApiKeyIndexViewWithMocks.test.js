import { mockApiKeys } from "../../__tests__/testHelpers"
import ApiKeyCollection, { mockApiKeyCollection, mockFetch } from "../ApiKeyCollection"
import { ApiKeyIndexView } from "../ApiKeyIndexView"

jest.mock("../ApiKeyCollection")

let view
beforeEach(() => {
  mockApiKeyCollection.mockClear()
  mockFetch.mockClear()
  view = new ApiKeyIndexView()
})

test("ApiKeyIndexView.render() creates/fetches an ApiKeyCollection and calls fetchSuccess on success", () => {
  const renderedView = view.render()

  expect(view).toBe(renderedView)
  expect(view.el).toMatchSnapshot()
  expect(mockApiKeyCollection).toHaveBeenCalled()
  expect(mockFetch).toHaveBeenCalled()
  expect(mockFetch.mock.calls[0][0].success.name).toBe("bound fetchSuccess")
})

// test("view.edit creates an AccountForm and displays it", () => {
//   const html = jest.fn()
//   const modal = jest.fn()
//   const text = jest.fn()
//   window.$ = jest.fn().mockImplementation(() => {
//     return { modal, html, text }
//   })

//   view.edit(mockAccountAssets)

//   expect(html).toHaveBeenCalledWith(view.form.el)
//   expect(text).toHaveBeenCalledWith("Edit Account")
//   expect(modal).toHaveBeenCalled()
// })

// test("view.edit rerenders the view when the saved event is triggered", () => {
//   const html = jest.fn()
//   const modal = jest.fn()
//   const text = jest.fn()
//   window.$ = jest.fn().mockImplementation(() => {
//     return { modal, html, text }
//   })

//   view.render = jest.fn()
//   view.edit(mockAccountAssets)
//   view.form.trigger("saved")

//   expect(view.render).toHaveBeenCalled()
// })

// test("view.creates displays an AccountForm with a default AccountModel", () => {
//   const html = jest.fn()
//   const modal = jest.fn()
//   const text = jest.fn()
//   window.$ = jest.fn().mockImplementation(() => {
//     return { modal, html, text }
//   })

//   view.create(mockAccountAssets)

//   expect(html).toHaveBeenCalledWith(view.form.el)
//   expect(text).toHaveBeenCalledWith("Create Account")
//   expect(modal).toHaveBeenCalled()
// })

// test("view.create renders itself when the saved event is triggered", () => {
//   const html = jest.fn()
//   const modal = jest.fn()
//   const text = jest.fn()
//   window.$ = jest.fn().mockImplementation(() => {
//     return { modal, html, text }
//   })

//   view.render = jest.fn()
//   view.create(mockAccountAssets)
//   view.form.trigger("saved")

//   expect(view.render).toHaveBeenCalled()
// })

// test("view.delete calls model.destroy then renders itself", () => {
//   mockAccountAssets.destroy = jest.fn().mockResolvedValue("promises")
//   view.render = jest.fn()

//   expect.assertions(2)
//   view.delete(mockAccountAssets).then(() => {
//     expect(mockAccountAssets.destroy).toHaveBeenCalled()
//     expect(view.render).toHaveBeenCalled()
//   })
// })