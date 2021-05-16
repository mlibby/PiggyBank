<template>
<main>
  <div>
    <h1>Loan Amortization Calculator</h1>
  </div>
  <div class='columns'>
    <div class='column column-1-4'>
      <section>
        <h2>Loan Details</h2>
        <form v-on:submit='calculate'>
          <label for='principal'>Loan Amount</label>
          <input id='principal' type='number' step='0.01' v-model='principal' required />
          <label for='rate'>Interest Rate</label>
          <input id='rate' type='number' step='0.01' v-model='rate' required/>
          <label for='number'>Number of Payments</label>
          <input id='number' type='number' v-model='number' required/>
          <label for='periods'>Payment Period</label>
          <select id='periods' v-model='periods'>
            <option value='1'>Annually</option>
            <option value='12'>Monthly</option>
            <option value='52'>Weekly</option>
          </select>
          <button>Calculate</button>
        </form>
        <div>{{ msg }}</div>
      </section>
      <section v-if='payments'>
        <h2>Loan Summary</h2>
        <dl>
          <dt>Total Interest</dt>
          <dd>{{ total_interest }}</dd>
        </dl>
      </section>
    </div>
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
          <td>{{ formatCurrency(payment.principal) }}</td>
          <td>{{ formatCurrency(payment.interest) }}</td>
          <td>
            <input type='number' step='0.01' v-model='payment.prepay' />
          </td>
          <td>{{ formatCurrency(payment.balance) }}</td>
        </tr>
      </table>
    </section>
  </div>
</main>
</template>

<script>
import axios from 'axios';
import { Decimal } from 'decimal.js';
import formatCurrency from '../../util.js';

export default {
  name: 'Amortization',
  title: 'Amortization',
  data: function(){
    return {
      msg: '',
      number: 360,
      payments: null,
      periods: 12,
      principal: Decimal('225000.0'),
      rate: Decimal('4.25'),
      total_interest: formatCurrency(Decimal('0.00'))
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
          this.total_interest = formatCurrency(response.data.total_interest);
          this.msg = '';
        });
    },
    totalPayment(payment) {
      const principal = new Decimal(payment.principal);
      const interest = new Decimal(payment.interest);
      const prepay = new Decimal(payment.prepay);
      const total = principal.plus(interest).plus(prepay);
      return formatCurrency(total.toFixed(2));
    },
    formatCurrency(amount) {
      return formatCurrency(amount);
    }
  },
};
</script>

<style>
  dd {
  margin-left: 0;
  margin-top: 0.33rem;
  }
  
  dt {
  font-weight: bold;
  }
  
table input[type=number] {
    width: 7rem;
}
</style>
