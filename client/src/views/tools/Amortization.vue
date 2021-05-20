<template>
<main>
  <div>
    <h1>Loan Amortization Calculator</h1>
    <p>
      You may enter an "extra" principal payment that will be applied to
      every payment. You may also enter lump sum extra principal payments
      once you have generated the amortization table. You can apply both
      kinds of extra principal payments.
    </p>
  </div>
  <div class='columns'>
    <div class='column column-1-4'>
      <section>
        <h2>Loan Details</h2>
        <form v-on:submit='calculate'>
          <label for='principal'>Loan Amount</label>
          <input id='principal' type='number' step='0.01' v-model='principal' required />
          <label for='rate'>Interest Rate</label>
          <input id='rate' type='number' step='0.001' v-model='rate' required/>
          <label for='number'>Number of Payments</label>
          <input id='number' type='number' v-model='number' required/>
          <label for='periods'>Payment Period</label>
          <select id='periods' v-model='periods'>
            <option value='1'>Annually</option>
            <option value='12'>Monthly</option>
            <option value='52'>Weekly</option>
          </select>
          <label for='extra-amount'>Extra Payment</label>
          <input id='extra-amount' type='number' step='0.01' v-model='extra_amount' />
          <spinner-button :onClick='calculate'>Calculate</spinner-button>
        </form>
        <div>{{ msg }}</div>
      </section>
      <section v-if='payments'>
        <h2>Loan Summary</h2>
        <dl>
          <dt>Payment Amount</dt>
          <dd>{{ payment_amount }}</dd>
          <dt>Total Interest</dt>
          <dd>{{ total_interest }}</dd>
          <dt>Interest Saved</dt>
          <dd>{{ saved_interest }}</dd>
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
          <th v-if='show_extra'>Extra</th>
          <th>Extra</th>
          <th>Balance</th>
        </tr>
        <tr v-for='payment in payments' :key='payment.number'>
          <td>{{ payment.number }}</td>
          <td>{{ formatCurrency(payment.total) }}</td>
          <td>{{ formatCurrency(payment.principal) }}</td>
          <td>{{ formatCurrency(payment.interest) }}</td>
          <td v-if='show_extra'>
            {{ formatCurrency(payment.extra_amount) }}
          </td>
          <td>
            <input type='number' step='0.01' v-model='payment.extra_lump' />
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
import { formatCurrency } from '../../util.js';
import SpinnerButton from '@/components/SpinnerButton.vue';

export default {
    name: 'Amortization',
    title: 'Amortization',
    components: {
        SpinnerButton,
    },
    data: function(){
        return {
            msg: '',
            number: 360,
            payments: null,
            periods: 12,
            principal: Decimal('225000.0'),
            rate: Decimal('4.25'),
            total_interest: formatCurrency(Decimal('0.00')),
            saved_interest: Decimal('0.00'),
            extra_amount: Decimal('0.00'),
            show_extra: false
        };
    },
    methods: {
        calculate(next) {
            const data = {
                principal: this.principal,
                rate: this.rate,
                number: this.number,
                periods: this.periods,
                payment_amount: null,
                payments: null,
                extra_amount: this.extra_amount,
                extra_lumps: this.getExtraLumps()
            };
            axios
                .post('/api/tools/amortization', data)
                .then((response) => {
                    const data = response.data;
                    this.payment_amount = formatCurrency(data.payment_amount);
                    this.payments = data.payments;
                    this.total_interest = formatCurrency(data.total_interest);
          let saved_interest = data.original_interest - data.total_interest;
          this.saved_interest = formatCurrency(saved_interest);
          this.show_extra = data.extra_amount > 0
            next();
        });
    },
    totalPayment(payment) {
      const principal = new Decimal(payment.principal);
      const interest = new Decimal(payment.interest);
      const extraAmount = new Decimal(this.extra_amount);
      const extra = new Decimal(payment.extra);
      const total = principal.plus(interest).plus(extra).plus(extraAmount);
      return formatCurrency(total.toFixed(2));
    },
    formatCurrency(amount) {
      return formatCurrency(amount);
    },
    getExtraLumps() {
      const lumps = {};
      if(this.payments) {
        this.payments.forEach((payment) => {
          if(Number(payment.extra_lump) > 0) {
            lumps[payment.number] = payment.extra_lump;
          }
        });
      }
      return lumps;
    }   
  },
};
</script>

<style>
dd {
    margin-left: 0;
    margin-top: 0.33rem;
    margin-bottom: 1rem;
}

dt {
    font-weight: bold;
    margin-bottom: 0;
}

table input[type=number] {
    width: 7rem;
}
</style>
