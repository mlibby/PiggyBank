"use strict"

import { html, render as renderHtml } from "../../lib/lit-html/lit-html.js"
import { Amortization } from "../finance/amortization.js"

const template = (d) => html`
  <div class='row'>
    <div class='col'>
      <h1>Mortgage Amortization</h1>
    </div>
  </div>
  <form class='form'>
    <div class='row'>
      <div class='form-group col-3'>
        <label for='loan-amount'>Loan Amount</label>
        <input id='loan-amount' class='form-control' type='number' value='0.0' />
      </div>
      <div class='form-group col-3'>
        <label for='interest-rate'>Interest Rate (% APR)</label>
        <input id='interest-rate' class='form-control' type='number' value='0.0' />
      </div>
      <div class='form-group col-3'>
        <label for='payments'>Payments</label>
        <input id='payments' class='form-control' type='number' value='0' />
      </div>
      <div class='form-group col-3'>
        <label for='payment-period'>Payment Period</label>
        <select id='payment-period' class='form-control'>
          <option>Monthly</option>
        </select>
      </div>
    </div>
    <div class='row'>
      <div class='form-group col'>
        <button class='calculate btn btn-success'><span class='icon-calculator'></span> Calculate</button>
      </div>
    </div>
  </form>
  <div class='row'>
    <div class='col'>
      <h2>Payment Amount: <span id="payment-amount">--.--</span></h2>
    </div>
  </div>
  <div class='row'>
    <div class='col'>
      <table id='payment-schedule' class='table'></table>
    </div>
  </div>
`

export class MortgageAmortizationView extends Backbone.View {
  constructor() {
    super()
    this.amortization = null
    this.commodity = piggybank.commodities.at(0)
  }

  render() {
    renderHtml(template(), this.el)

    this.$(".btn.calculate").on("click", this.calculate.bind(this))

    return this
  }

  calculate(e) {
    e.preventDefault()
    const principal = Number(this.$("#loan-amount").val()) * 100
    const rate = Number(this.$("#interest-rate").val()) / 1200
    const number = Number(this.$("#payments").val())
    this.amortization = new Amortization(principal, rate, number)

    const paymentAmount = this.commodity.toString(this.amortization.paymentAmount)
    this.$("#payment-amount").text(paymentAmount)
    this.renderScheduleRows()
  }

  renderScheduleRows(payments) {
    const $paymentSchedule = this.$("#payment-schedule")
    $paymentSchedule.children().remove()
    this.amortization.payments.forEach((payment, i) => {
      const $paymentRow = $("<tr></tr>")
      $paymentRow.append($(`<td>${i + 1}</td>`))
      $paymentRow.append($(`<td>${this.commodity.toString(payment.paymentAmount)}</td>`))
      $paymentRow.append($(`<td>${this.commodity.toString(payment.interest)}</td>`))
      $paymentRow.append($(`<td>${this.commodity.toString(payment.principal)}</td>`))
      $paymentRow.append($(`<td>${this.commodity.toString(payment.balance)}</td>`))
      $paymentSchedule.append($paymentRow)
    })
  }
}
