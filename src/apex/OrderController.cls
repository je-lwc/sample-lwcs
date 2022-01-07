public with sharing class OrderController {
  @AuraEnabled(Continuation=true)
  public static Object placeOrder(Order order) {
    UxApiHelper.RequestParams req = new UxApiHelper.RequestParams();
    req.method = UxApiHelper.HttpMethod.HTTP_POST;
    req.path = 'order';
    return UxApiHelper.sendRequestContinuation(req, 'placeOrderCallback');
  }

  @AuraEnabled(Continuation=true)
  public static String placeOrderCallback(Object state) {
    try {
      HttpResponse res = Continuation.getResponse((String) state);
      if (response.getStatusCode() < 200 || response.getStatusCode() > 299) {
        System.debug(response.getBody());
        throw new AuraHandledException('API error occurred');
      }
      Order order = Order.getFromJSON(response.getBody());
      System.enqueueJob(new SaveOrderJob(order));
      return order.orderId;
    } catch(Exception e) {
      System.debug(e);
    }
    return null;
  }

  @AuraEnabled(Cacheable=true)
  public static List<Toppings> getToppings(){
    // ...
  }

  class SaveOrderJob implements Queueable, Database.AllowsCallouts {
    Order__c o;

    public SaveOrder(Order order) {
      o = new Order__c(
        Opportunity__c = order.opportunityId;
        OrderDate__c = order.timestamp;
        Tracking_Key__c = order.orderId;
      )
    }

    public void execute(QueueableContext ctx) {
      upsert o Tracking_Key__c;
    }
  }
}
