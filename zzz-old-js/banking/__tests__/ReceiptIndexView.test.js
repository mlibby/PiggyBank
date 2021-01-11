import { mockEvent } from "../../__tests__/testHelpers"
import { ReceiptIndexView } from "../ReceiptIndexView"

let view

beforeEach(() => {
  view = new ReceiptIndexView()
})

test("ReceiptIndexView.render() get media permissions", () => {
  const renderedView = view.render()
  expect(view).toBe(renderedView)
  expect(view.el).toMatchSnapshot()
  expect(navigator.mediaDevices.getUserMedia).toHaveBeenCalledWith({
    audio: false,
    video: true
  })
})

test("ReceiptIndexView.handleSuccess() hooks up video stream and listens to snaphot buttonnpx", () => {
  const mockVideo = { srcObject: null }
  const mockOn = jest.fn()
  view.$ = jest.fn().mockReturnValue({
    0: mockVideo,
    on: mockOn
  })
  const mockStream = {
    getVideoTracks: jest.fn().mockReturnValue(["mock track"])
  }
  global.ImageCapture = jest.fn()

  view.handleSuccess(mockStream)

  expect(mockStream.getVideoTracks).toHaveBeenCalled()
  expect(mockVideo.srcObject).toBe(mockStream)
  expect(global.ImageCapture).toHaveBeenCalledWith("mock track")
  expect(mockOn).toHaveBeenCalledWith("click", expect.anything())
})

test("ReceiptIndexView.takeSnapshot() takes a still from the stream", () => {
  const mockVideo = { srcObject: null }
  const mockOn = jest.fn()
  view.$ = jest.fn().mockReturnValue({
    0: mockVideo,
    on: mockOn
  })
  const mockStream = {
    getVideoTracks: jest.fn().mockReturnValue(["mock track"])
  }
  const mockTakePhoto = jest.fn().mockResolvedValue({ foo: "bar" })
  global.ImageCapture = jest.fn().mockReturnValue({
    takePhoto: mockTakePhoto
  })

  view.handleSuccess(mockStream)

  var mockPhotoElem = {}
  window.$ = jest.fn().mockReturnValue(mockPhotoElem);
  view.takeSnapshot(mockEvent).then(() => {
    expect(mockEvent.preventDefault).toHaveBeenCalled()
    expect(mockTakePhoto).toHaveBeenCalled()
    expect(URL.createObjectURL).toHaveBeenCalled()
    expect(mockPhotoElem.onload).not.toBeUndefined()
    mockPhotoElem.onload()
    expect(URL.revokeObjectURL).toHaveBeenCalled()
  })
})

test("ReceiptIndexView.takeSnapshot() with error alerts user", () => {
  const mockVideo = { srcObject: null }
  const mockOn = jest.fn()
  view.$ = jest.fn().mockReturnValue({
    0: mockVideo,
    on: mockOn
  })
  const mockStream = {
    getVideoTracks: jest.fn().mockReturnValue(["mock track"])
  }
  const mockTakePhoto = jest.fn().mockRejectedValue("mock error")
  global.ImageCapture = jest.fn().mockReturnValue({
    takePhoto: mockTakePhoto
  })

  view.handleSuccess(mockStream)

  var mockPhotoElem = {}
  view.$ = jest.fn().mockReturnValue(mockPhotoElem);
  window.alert = jest.fn()
  view.takeSnapshot(mockEvent).then(() => {
    expect(mockTakePhoto).toHaveBeenCalled()
    expect(window.alert).toHaveBeenCalledWith("Error: mock error")
  })
})