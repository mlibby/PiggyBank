<template>
<main>
  <h1>Loan Amortization Calculator</h1>
  <form v-on:submit='calculate'>
    <label>
      Loan Amount
      <input id='principal' type='number' step='0.01' />
    </label>
    <label>
      Interest Rate
      <input id='rate' type='number' step='0.01' />
    </label>
    <label>
      Number of Payments
      <input id='number' type='number' />
    </label>
    <label>
      Payment Period
      <select id='period'>
        <option>Monthly</option>
      </select>
    </label>
    <button>Calculate</button>
  </form>
  <div>{{ msg }}</div>
  <table v-if='payments'>
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
      <td>{{ payment.prepay }}</td>
      <td>{{ payment.balance }}</td>
    </tr>
  </table>
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
      payments: null,
      msg: '',
    };
  },
  methods: {
    calculate(e) {
      e.preventDefault();
      this.msg = 'Calculating...';
      axios
        .post('/api/tools/amortization', {})
        .then((response) => {
          this.payments = response.data;
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
