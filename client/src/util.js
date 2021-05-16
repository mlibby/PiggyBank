import { Decimal } from 'decimal.js'; 

export default {
  formatCurrency(amount) {
  if(amount.__proto__.name === '[object Decimal]') {
    return amount.toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,');
  }
  else {
    return this.formatCurrency(Decimal(amount));
  }
  }
}
