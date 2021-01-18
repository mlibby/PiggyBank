# TODO: translate from JS

# import { Amortization } from "../amortization"

# test("Amortization calculates payment amount", () => {
#   const amort = new Amortization(10000000, 0.06/12, 360)
#   expect(amort.paymentAmount).toBe(59955)
# })

# test("Amortization calculates payment schedule", () => {
#   const amort = new Amortization(10000000, 0.06/12, 360)
#   expect(amort.payments.length).toBe(360)

#   //final payment is a "balloon" payment with extra principal
#   expect(amort.payments[359].paymentAmount).toBe(60000)
# })

# "use strict"

# export class Amortization {
#   constructor(principal, rate, number) {
#     this.principal = principal
#     this.rate = rate
#     this.number = number
#     this.paymentAmount = this._calculatePaymentAmount()
#     this.payments = this._calculatePayments()
#   }

#   _calculatePaymentAmount() {
#     const pmtRate = Math.pow(1 + this.rate, this.number)
#     const pmtNum = this.principal * this.rate * pmtRate
#     const pmtDen = pmtRate - 1
#     const pmt = Math.round(pmtNum / pmtDen)
#     return pmt
#   }

#   _calculatePayments() {
#     let balance = this.principal
#     const payments = []

#     while(balance > 0) {
#       const payment = {
#         paymentAmount: this.paymentAmount,
#         interest: Math.round(balance * this.rate)
#       }
#       payment.principal = this.paymentAmount - payment.interest
#       balance = payment.balance = balance - payment.principal

#       const nextInterest = Math.round(balance * this.rate)
#       if(nextInterest + balance < this.paymentAmount) {
#         payment.principal = payment.principal + balance
#         payment.paymentAmount = payment.principal + payment.interest
#         balance = payment.balance = 0
#       }

#       payments.push(payment)
#     }

#     return payments
#   }
# }