import { LightningElement } from 'lwc';

const size = [
  { label: 'Small', value: '10"' },
  { label: 'Medium', value: '12"' },
  { label: 'Large', value: '14"' },
  { label: 'Extra Large', value: '16"' }
];

const crust = [
  {
    label: 'Thin Crust',
    value: 'Thin',
    price: [
      { size: '10"', value: 6 },
      { size: '12"', value: 8 },
      { size: '14"', value: 10 },
      { size: '16"', value: 12 }
    ]
  },
  {
    label: 'Original Crust',
    value: 'Original',
    price: [
      { size: '10"', value: 5 },
      { size: '12"', value: 5 },
      { size: '14"', value: 6 },
      { size: '16"', value: 7 }
    ]
  },
  {
    label: 'Crunchy Crispy',
    value: 'Crunchy',
    price: [
      { size: '10"', value: 15 },
      { size: '12"', value: 15 },
      { size: '14"', value: 15 },
      { size: '16"', value: 15 }
    ]
  }
];

const toppingFilters = [
  { label: 'Non-Vegetarian', value: '' },
  { label: 'Vegetarian', value: 'Vegetarian' },
  { label: 'Vegan', value: 'Vegan' }
];

const toppings = [
  { label: 'Pepperoni', value: 'Pepperoni', type: 'Meat', price: 3.05 },
  { label: 'Sausage', value: 'Sausage', type: 'Meat', price: 3.05 },
  { label: 'Beef Crumble', value: 'Beef Crumble', type: 'Meat', price: 4.79 },
  { label: 'Ham', value: 'Ham', type: 'Meat', price: 3.05 },
  { label: 'Bacon', value: 'Bacon', type: 'Meat', price: 3.05 },
  { label: 'Chicken', value: 'Chicken', type: 'Meat', price: 5.29 },
  { label: 'Philly Steak', value: 'Philly Steak', type: 'Meat', price: 6.99 },
  { label: 'Anchovy', value: 'Anchovy', type: 'Meat', price: 6.99 },
  { label: 'Cheddar', value: 'Cheddar', type: 'Dairy', price: 1.29 },
  { label: 'Feta', value: 'Feta', type: 'Dairy', price: 1.29 },
  { label: 'Parmesan Asiago', value: 'Parmesan Asiago', type: 'Dairy', price: 1.59 },
  { label: 'Provolone', value: 'Provolone', type: 'Dairy', price: 2.39 },
  { label: 'Hot Banana Peppers', value: 'Hot Banana Peppers', type: 'Vege', price: 1 },
  { label: 'Black Olives', value: 'Black Olives', type: 'Vege', price: 0.99 },
  { label: 'Green Olives', value: 'Green Olives', type: 'Vege', price: 0.99 },
  { label: 'Green Pepper', value: 'Green Pepper', type: 'Vege', price: 0.99 },
  { label: 'Mushroom', value: 'Mushroom', type: 'Vege', price: 0.99 },
  { label: 'Pineapple', value: 'Pineapple', type: 'Vege', price: 0.99 },
  { label: 'Onion', value: 'Onion', type: 'Vege', price: 0.99 },
  { label: 'Tomatoes', value: 'Tomatoes', type: 'Vege', price: 2.99 },
  { label: 'Spinach', value: 'Spinach', type: 'Vege', price: 1.99 }
];
export default class PizzaBuilder extends LightningElement {
  get sizeOptions() {
    return [...size];
  }
  get crustOptions() {
    return [...crust];
  }

  get toppingFilters() {
    return [...toppingFilters];
  }

  get toppingOptions() {
    return toppings.filter((el) => {
      if (this.toppingFilter === 'Vegetarian') {
        return el.type !== 'Meat';
      }
      if (this.toppingFilter === 'Vegan') {
        return el.type !== 'Meat' && el.type !== 'Dairy';
      }
      return true;
    });
  }

  renderedCallback() {
    this.template.querySelectorAll('.toppings input[type="checkbox"]').forEach((el) => {
      if (this.toppings.includes(el.value)) {
        el.checked = true;
      }
    });
  }

  size = '12"';
  crust = 'Original';
  toppingFilter = '';
  toppings = [];

  handleSizeSelection({ detail: { value } }) {
    this.size = value;
  }
  handleCrustSelection({ detail: { value } }) {
    this.crust = value;
  }
  handleToppingFilter({ detail: { value } }) {
    this.toppingFilter = value;
  }
  handleToppingSelection({ currentTarget: { value, checked } }) {
    if (checked) {
      this.toppings = [...this.toppings, value];
    } else {
      this.toppings = this.toppings.filter((v) => v !== value);
    }
  }
}
