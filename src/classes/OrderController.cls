public with sharing class OrderController {
  @AuraEnabled(Continuation=true)
  public static Object placeOrder(FoodOrder order) {
    UxApiHelper.RequestParams req = new UxApiHelper.RequestParams();
    req.method = UxApiHelper.HttpMethod.HTTP_POST;
    req.path = 'order';
    req.body = order.toString();
    return UxApiHelper.sendRequestContinuation(req, 'placeOrderCallback');
  }

  @AuraEnabled(Continuation=true)
  public static String placeOrderCallback(Object state) {
    try {
      HttpResponse res = Continuation.getResponse((String) state);
      if (res.getStatusCode() < 200 || res.getStatusCode() > 299) {
        System.debug(res.getBody());
        throw new AuraHandledException('API error occurred');
      }
      FoodOrder order = FoodOrder.getFromJSON(res.getBody());
      System.enqueueJob(new SaveOrderJob(order));
      return order.orderId;
    } catch (Exception e) {
      System.debug(e);
    }
    return null;
  }

  @AuraEnabled(Cacheable=true)
  public static List<Toppings> getToppings() {
    // ... Implementation code omitted
  }

  @AuraEnabled
  public static void cancelOrder(Id opportunityId) {
    UxApiHelper.RequestParams req = new UxApiHelper.RequestParams();
    req.method = UxApiHelper.HttpMethod.HTTP_PUT;
    req.path = 'order';
    req.body = '{"referenceId":"' + opportunityId + '", "status":"cancelled"}';
    HttpResponse res = UxApiHelper.sendRequest(req);
    if (res.getStatusCode() < 200 || res.getStatusCode() > 299) {
      throw new AuraHandledException('API error occurred');
    }
  }

  class SaveOrderJob implements Queueable, Database.AllowsCallouts {
    FoodOrder__c o;

    public SaveOrderJob(FoodOrder order) {
      o = new FoodOrder__c(
        Opportunity__c = order.opportunityId,
        OrderDate__c = order.timestamp,
        Tracking_Key__c = order.orderId
      );
    }

    public void execute(QueueableContext ctx) {
      upsert o Tracking_Key__c;
    }
  }
}
