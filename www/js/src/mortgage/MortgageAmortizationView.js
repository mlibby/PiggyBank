"use strict"

import { html, render as renderHtml } from "../../lib/lit-html/lit-html.js"

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
        <label for='interest-rate'>Interest Rate</label>
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
`

export class MortgageAmortizationView extends Backbone.View {
  render() {
    renderHtml(template(), this.el)

    this.$(".btn.calculate").on("click", this.calculate)

    return this
  }

  calculate(e) {
    e.preventDefault()
  }
}
