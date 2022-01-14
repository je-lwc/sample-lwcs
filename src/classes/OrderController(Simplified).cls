public with sharing class OrderController {
  @AuraEnabled
  public static String placeOrder(Order order) {
    UxApiHelper.RequestParams req = new UxApiHelper.RequestParams();
    req.method = UxApiHelper.HttpMethod.HTTP_POST;
    req.path = 'order';

    try {
      HttpResponse res = UxApiHelper.sendRequest(req);
      if (res.getStatusCode() < 200 || res.getStatusCode() > 299) {
        System.debug(res.getBody());
        throw new AuraHandledException('API error occurred');
      }
      Order order = Order.getFromJSON(res.getBody());
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
  public static cancelOrder(Id opportunityId) {
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
    Order__c o;

    public SaveOrder(Order order) {
      o = new Order__c(
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
