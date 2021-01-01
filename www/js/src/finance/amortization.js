"use strict"

export class Amortization {
  constructor(principal, rate, number) {
    this.principal = principal
    this.rate = rate
    this.number = number
    this.payment = this.#calculatePayment()
  }

  #calculatePayment() {
    const pmtRate = Math.pow(1 + this.rate, this.number)
    const pmtNum = this.principal * this.rate * pmtRate
    const pmtDen = pmtRate - 1
    const pmt = Math.round(pmtNum / pmtDen)
    return pmt
  }
}