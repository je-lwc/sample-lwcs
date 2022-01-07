import { LightningElement } from 'lwc';

const size = [
  { label: 'Small', value: '10"' },
  { label: 'Medium', value: '12"' },
  { label: 'Large', value: '14"' },
  { label: 'Extra Large', value: '16"' }
];

const crust = [
  { label: 'Thin Crust', value: 'Thin' },
  { label: 'Original Crust', value: 'Original' },
  { label: 'Crunchy Crispy', value: 'Crunchy' }
];

const toppings = [
  { label: 'Pepperoni', value: 'Pepperoni', type: 'Meat' },
  { label: 'Sausage', value: 'Sausage', type: 'Meat' },
  { label: 'Beef Crumble', value: 'Beef Crumble', type: 'Meat' },
  { label: 'Ham', value: 'Ham', type: 'Meat' },
  { label: 'Bacon', value: 'Bacon', type: 'Meat' },
  { label: 'Chicken', value: 'Chicken', type: 'Meat' },
  { label: 'Philly Steak', value: 'Philly Steak', type: 'Meat' },
  { label: 'Anchovy', value: 'Anchovy', type: 'Meat' },
  { label: 'Cheddar', value: 'Cheddar', type: 'Dairy' },
  { label: 'Feta', value: 'Feta', type: 'Dairy' },
  { label: 'Parmesan Asiago', value: 'Parmesan Asiago', type: 'Dairy' },
  { label: 'Provolone', value: 'Provolone', type: 'Dairy' },
  { label: 'Hot Banana Peppers', value: 'Hot Banana Peppers', type: 'Vege' },
  { label: 'Black Olives', value: 'Black Olives', type: 'Vege' },
  { label: 'Green Olives', value: 'Green Olives', type: 'Vege' },
  { label: 'Green Pepper', value: 'Green Pepper', type: 'Vege' },
  { label: 'Mushroom', value: 'Mushroom', type: 'Vege' },
  { label: 'Pineapple', value: 'Pineapple', type: 'Vege' },
  { label: 'Onion', value: 'Onion', type: 'Vege' },
  { label: 'Tomatoes', value: 'Tomatoes', type: 'Vege' },
  { label: 'Spinach', value: 'Spinach', type: 'Vege' }
];
export default class App extends LightningElement {
  get sizeOptions() {
    return [...size];
  }
  get crustOptions() {
    return [...crust];
  }

  toppingFilters = [
    { label: 'Non-Vegetarian', value: '' },
    { label: 'Vegetarian', value: 'Vegetarian' },
    { label: 'Vegan', value: 'Vegan' }
  ];

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
}
