<template>
<main>
  <div>
    <h1>Loan Amortization Calculator</h1>
  </div>
  <div class='columns'>
    <section class='column column-1-4'>
      <h2>Loan Details</h2>
      <form v-on:submit='calculate'>
        <label for='principal'>Loan Amount</label>
        <input id='principal' type='number' step='0.01' v-model='principal' />
        <label for='rate'>Interest Rate</label>
        <input id='rate' type='number' step='0.01' v-model='rate' />
        <label for='number'>Number of Payments</label>
        <input id='number' type='number' v-model='number' />
        <label for='periods'>Payment Period</label>
        <select id='periods' v-model='periods'>
          <option value='12'>Monthly</option>
        </select>
        <button>Calculate</button>
      </form>
      <div>{{ msg }}</div>
    </section>
    <section v-if='payments' class='column'>
      <h2>Payment Schedule</h2>
      <table>
        <tr>
          <th>Number</th>
          <th>Payment</th>
          <th>Principal</th>
          <th>Interest</th>
          <th>Prepay</th>
          <th>Balance</th>
        </tr>
        <tr v-for='payment in payments'>
          <td>{{ payment.number }}</td>
          <td>{{ totalPayment(payment) }}</td>
          <td>{{ payment.principal }}</td>
          <td>{{ payment.interest }}</td>
          <td>
            <input type='number' step='0.01' v-model='payment.prepay' />
          </td>
          <td>{{ payment.balance }}</td>
        </tr>
      </table>
    </section>
  </div>
</main>
</template>

<script>
import axios from 'axios';
import { Decimal } from 'decimal.js';

export default {
  name: 'Amortization',
  title: 'Amortization',
  data: function(){
    return {
      principal: Decimal('225000.0'),
      rate: Decimal('4.25'),
      number: 360,
      periods: 12,
      payments: null,
      msg: '',
    };
  },
  methods: {
    calculate(e) {
      e.preventDefault();
      this.msg = 'Calculating...';
      const data = {
        principal: this.principal,
        rate: this.rate,
        number: this.number,
        periods: this.periods,
        payments: null,
      };
      axios
        .post('/api/tools/amortization', data)
        .then((response) => {
          this.payments = response.data.payments;
          this.msg = '';
        });
    },
    totalPayment(payment) {
      const principal = new Decimal(payment.principal);
      const interest = new Decimal(payment.interest);
      const prepay = new Decimal(payment.prepay);
      const total = principal.plus(interest).plus(prepay);
      return total.toFixed(2);
    },
  },
};
</script>

<style>
  table input[type=number] {
  width: 7rem;
}
</style>
