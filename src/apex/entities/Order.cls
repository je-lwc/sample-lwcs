public with sharing class Order {
  @AuraEnabled
  public Id opportunityId;

  @AuraEnabled
  public String orderId;

  @AuraEnabled
  public DateTime timestamp;

  @AuraEnabled
  public String idempotencyKey;

  @AuraEnabled
  public List<Pizza> pizzas;

  @AuraEnabled
  public String status;

  public String toString() {
    JSONGenerator jg = JSON.createGenerator(false);
    jg.writeStartObject();
    jg.writeStringField('orderDateTime', DateTimeHelper.dateTimeToIsoString(timestamp));
    jg.writeStringField('referenceId', opportunityId);
    if (String.isNotEmpty(idempotencyKey)) {
      jg.writeStringField('idempotencyKey', idempotencyKey);
    }
    jg.writeFieldName('items');
    jg.writeStartArray();
    for (Pizza pizza : pizzas) {
      jg.writeStartObject();
      jg.writeStringField('size', pizza.size);
      jg.writeStringField('crust', pizza.crust);
      if (pizza.toppings != null && toppings.size() > 0) {
        jg.writeFieldName('toppings');
        jg.writeStartArray();
        for (String t : pizza.toppings) {
          jg.writeString(t);
        }
        jg.writeEndObject();
      }
      jg.writeEndObject();
    }
    jg.writeEndArray();
    jg.writeEndObject();
    return jg.getAsString();
  }

  public static Order getFromJSON(String json) {
    Order o = new Order();
    Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(json);
    o.opportunityId = String.valueOf(m.get('referenceId'));
    o.timestamp = DateTimeHelper.stringToDateTime(m.get('orderDateTime'));
    o.status = String.valueOf(m.get('status'));
    o.pizzas = new List<pizzas>();
    for (Object oo : (List<Object>) m.get('items')) {
      Map<String, Object> item = (Map<String, Object>) oo;
      Pizza p = new Pizza();
      p.size = String.valueOf(oo.get('size'));
      p.crust = String.valueOf(oo.get('crust'));
      p.toppings = new List<String>();
      for (Object t : (List<Object>) oo.get('toppings')) {
        p.toppings.add(String.valueOf(t));
      }
      o.pizzas.add(p);
    }
    return o;
  }
}
