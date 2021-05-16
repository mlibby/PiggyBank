import { Decimal } from 'decimal.js'; 

export function formatCurrency(amount) {
  if(amount.__proto__.name === '[object Decimal]') {
    return '$' + amount.toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,');
  }
  else {
    return formatCurrency(Decimal(amount));
  }
}

