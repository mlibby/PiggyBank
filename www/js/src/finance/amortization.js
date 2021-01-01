"use strict"

export class Amortization {
  constructor(principal, rate, number) {
    this.principal = principal
    this.rate = rate
    this.number = number
    this.paymentAmount = this.#calculatePaymentAmount()
    this.payments = this.#calculatePayments()
  }

  #calculatePaymentAmount() {
    const pmtRate = Math.pow(1 + this.rate, this.number)
    const pmtNum = this.principal * this.rate * pmtRate
    const pmtDen = pmtRate - 1
    const pmt = Math.round(pmtNum / pmtDen)
    return pmt
  }

  #calculatePayments() {
    let balance = this.principal
    const payments = []

    while(balance > 0) {
      const payment = {
        interest: Math.round(balance * this.rate)
      }
      payment.principal = this.paymentAmount - payment.interest
      balance = payment.balance = balance - payment.principal

      payments.push(payment)
    }

    return payments
  }
}