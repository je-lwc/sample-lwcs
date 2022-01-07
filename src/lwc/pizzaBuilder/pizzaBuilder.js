import { LightningElement } from 'lwc';

export default class App extends LightningElement {
  sizeOptions = [
    { label: 'Small', value: '10"' },
    { label: 'Medium', value: '12"' },
    { label: 'Large', value: '14"' },
    { label: 'Extra Large', value: '16"' }
  ];
  crustOptions = [
    { label: 'Thin Crust', value: 'Thin' },
    { label: 'Original Crust', value: 'Original' },
    { label: 'Crunchy Crispy', value: 'Crunchy' }
  ];

  size = '10"';
  crust = 'Original';

  handleSizeSelection() {}
}
