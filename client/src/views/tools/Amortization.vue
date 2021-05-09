<template>
  <main>
    <h1>Loan Amortization Calculator</h1>
    <form>
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
  </main>
</template>

<script>
export default {
  name: 'Amortization',
  title: 'Amortization',
};
</script>
