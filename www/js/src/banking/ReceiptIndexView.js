"use strict"

import { html, render } from "../../lib/lit-html/lit-html.js"

const template = (d) => html`
  <div class='row'>
    <div class='col'>
      <h1>Receipts</h1>
      <video playsinline autoplay style='width:340px;height:240px;'></video>
      <button id='snapshot-btn'>Take snapshot</button>
      <img id='snapshot-img' />
      <canvas></canvas>
    </div>
  </div>
`

const constraints = {
  audio: false,
  video: true
}

export class ReceiptIndexView extends Backbone.View {
  constructor() {
    super()
    this.imageCapture = null
  }

  render() {
    render(template(), this.el)

    navigator.mediaDevices
      .getUserMedia(constraints)
      .then(this.handleSuccess.bind(this))
      .catch(this.handleError)

    return this
  }

  // const video = document.querySelector('video');
  // canvas.width = video.videoWidth;
  // canvas.height = video.videoHeight;
  // canvas.getContext('2d').drawImage(video, 0, 0, canvas.width, canvas.height);
  // const canvas = window.canvas = document.querySelector('canvas');
  // canvas.width = 480;
  // canvas.height = 360;

  handleSuccess(stream) {
    const video = this.$("video")[0]
    video.srcObject = stream
    const mediaStreamTrack = stream.getVideoTracks()[0]
    this.imageCapture = new ImageCapture(mediaStreamTrack)

    this.$("#snapshot-btn").on("click", this.takeSnapshot.bind(this))
  }

  handleError(error) {
    console.log("navigator.MediaDevices.getUserMedia error: ", error.message, error.name)
  }

  async takeSnapshot(e) {
    e.preventDefault()
    const img = this.$("#snapshot-img")
    await this.imageCapture.takePhoto()
      .then(blob => {
        img.src = URL.createObjectURL(blob);
        img.onload = () => { URL.revokeObjectURL(this.src); }
      })
      .catch(error => {
        alert(`Error: ${error}`)
      })
  }

}
