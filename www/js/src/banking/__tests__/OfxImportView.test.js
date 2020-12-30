import { mockEvent } from "../../__tests__/testHelpers"
import { OfxImportView } from "../OfxImportView"

let view

beforeEach(() => {
  view = new OfxImportView()
})

test("ApiKeyView has render method", () => {
  const renderedView = view.render()
  expect(view).toBe(renderedView)
  expect(view.el).toMatchSnapshot()
})

