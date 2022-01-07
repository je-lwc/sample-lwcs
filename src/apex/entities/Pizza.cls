public with sharing class Pizza {
  @AuraEnabled
  public String size;
  @AuraEnabled
  public String crust;
  @AuraEnabled
  public List<String> toppings;
}
