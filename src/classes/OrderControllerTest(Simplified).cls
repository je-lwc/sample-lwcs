@IsTest
public without sharing class OrderControllerTest {
  static final String opportunityName = 'TEST_OPPO';
  static final String API_ORDER_ID = '982716';

  @TestSetup
  static void makeData() {
    TestObjectHelper.createPersistentOpportunity(opportunityName);
  }

  static FoodOrder getTestOrder() {
    Opportunity o = [SELECT Id FROM Opportunity WHERE Name = :opportunityName];
    FoodOrder order = new FoodOrder();
    Pizza pizza = new Pizza();
    order.opportunityId = o.Id;
    order.timestamp = System.now();
    order.idempotencyKey = '47135ecf-78fc-4ceb-af9d-a0437fe94cc5';
    order.pizzas = new List<Pizza>();
    order.pizzas.add(pizza);
    pizza.size = '12"';
    pizza.crust = 'Original';
    pizza.toppings = new List<String>();
    pizza.toppings.add('Bacon');
    pizza.toppings.add('Cheddar');
    pizza.toppings.add('Pineapple');
    return order;
  }

  @IsTest
  public static void placeOrderSuccessTest() {
    String body =
      '{"referenceId":"' +
      API_ORDER_ID +
      '","orderDateTime":"2022-01-01T02:24:58.840Z","status":"received","items":[{"size":"12\"","crust":"Original","toppings":["Bacon","Cheddar","Pineapple"]}]}';
    Test.setMock(HttpCalloutMock.class, new GenericHttpMock(201, body, null));
    Test.startTest();
    String result = OrderController.placeOrder(getTestOrder());
    System.assert(result == API_ORDER_ID, 'should receive order id from API');
  }

  @IsTest
  public static void placeOrderErrorTest() {
    Exception err = null;
    String body = '{"message":"Inerval Server Error."}';
    Test.setMock(HttpCalloutMock.class, new GenericHttpMock(500, body, null));
    Test.startTest();
    try {
      String result = OrderController.placeOrder(getTestOrder());
    } catch (Exception e) {
      err = e;
    }
    Test.stopTest();
    System.assert(err != null, 'Should throw exception');
  }
}
