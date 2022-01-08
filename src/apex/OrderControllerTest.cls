@IsTest
public without sharing class OrderControllerTest {
  static final String opportunityName = 'TEST_OPPO';
  static final String placeOrderCallbackLabel = 'CONTINUATION_PLACE_ORDER_CALLBACK_TEST';
  static final String API_ORDER_ID = '982716';
  static Map<String, String> conLabels = new Map<String, String>();

  @TestSetup
  static void makeData() {
    TestObjectHelper.createPersistentOpportunity(opportunityName);
  }

  static Continuation callPlaceOrder() {
    Opportunity o = [SELECT Id FROM Opportunity WHERE Name = :opportunityName];
    Order order = new Order();
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
    return (Continuation) OrderController.placeOrder(order);
  }

  static String placeOrderProxyCallback() {
    Object state = conLabels.get(placeOrderCallbackLabel);
    return OrderController.placeOrderCallback(state);
  }

  @IsTest
  public static void placeOrderSuccessTest() {
    String body =
      '{"referenceId":"' +
      API_ORDER_ID +
      '","orderDateTime":"2022-01-01T02:24:58.840Z","status":"received","items":[{"size":"12\"","crust":"Original","toppings":["Bacon","Cheddar","Pineapple"]}]}';
    Test.startTest();
    /*-- Start boiler plate code for continuation test --*/
    // call the caller method and get continuation
    Continuation con = callPlaceOrder();
    con.continuationMethod = 'placeOrderProxyCallback';
    // get request from continuation
    Map<String, HttpRequest> requests = con.getRequests();
    String label = (new List<String>(requests.keySet()))[0];
    HttpRequest request = requests.get(label);
    // store request label for callback method to use
    conLabels.put(makePaymentCallbackLabel, label);
    // set mock response for the request
    HttpCalloutMock mock = new GenericHttpMock(200, body, null);
    HttpResponse response = mock.respond(request);
    Test.setContinuationResponse(label, response);
    // using the test class as proxy to invoke callback method
    String result = (String) Test.invokeContinuationMethod(new OrderControllerTest(), con);
    /*-- End boiler place code for continuation test --*/
    System.assert(result == API_ORDER_ID, 'should receive order id from API');
  }

  @IsTest
  public static void placeOrderErrorTest() {
    Exception err = null;
    Test.startTest();
    /*-- Start boiler plate code for continuation test --*/
    // call the caller method and get continuation
    Continuation con = callPlaceOrder();
    con.continuationMethod = 'placeOrderProxyCallback';
    // get request from continuation
    Map<String, HttpRequest> requests = con.getRequests();
    String label = (new List<String>(requests.keySet()))[0];
    HttpRequest request = requests.get(label);
    // store request label for callback method to use
    conLabels.put(makePaymentCallbackLabel, label);
    // set mock response for the request
    HttpCalloutMock mock = new GenericHttpMock(500, body, null);
    HttpResponse response = mock.respond(request);
    Test.setContinuationResponse(label, response);
    // using the test class as proxy to invoke callback method
    try {
      String result = (String) Test.invokeContinuationMethod(new OrderControllerTest(), con);
    } catch (Exception e) {
      err = e;
    }
    /*-- End boiler place code for continuation test --*/
    System.assert(err != null, 'Should throw exception');
  }
}
