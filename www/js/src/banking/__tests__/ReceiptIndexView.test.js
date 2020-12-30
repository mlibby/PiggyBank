import { mockEvent } from "../../__tests__/testHelpers"
import { ReceiptIndexView } from "../ReceiptIndexView"

let view

beforeEach(() => {
  view = new ReceiptIndexView()
})

test("ReceiptIndexView has render method", () => {
  const renderedView = view.render()
  expect(view).toBe(renderedView)
  expect(view.el).toMatchSnapshot()
})

