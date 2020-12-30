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

let imageCapture

export class ReceiptIndexView extends Backbone.View {
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
    window.stream = stream
    const video = this.$("video")[0]
    video.srcObject = stream
    const mediaStreamTrack = stream.getVideoTracks()[0]
    imageCapture = new ImageCapture(mediaStreamTrack)

    this.$("#snapshot-btn").on("click", this.takeSnapshot)
  }

  handleError(error) {
    console.log("navigator.MediaDevices.getUserMedia error: ", error.message, error.name)
  }

  
  takeSnapshot(e) {
    e.preventDefault()
    const img = document.querySelector("#snapshot-img")
    imageCapture.takePhoto()
      .then(blob => {
        img.src = URL.createObjectURL(blob);
        img.onload = () => { URL.revokeObjectURL(this.src); }
      })
      .catch(error => console.error("takePhoto() error: ", error))
  }

}
