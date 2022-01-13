public without sharing class TestObjectHelper {
  public Opportunity createInMemoryOpportynity(String name) {
    Opportunity o = new Opportunity(
      Name = name,
      // ... add required fields
      Field_Z__c = ''
    );
    return o;
  }

  public Opportunity createPersistentOpportunity(String name) {
    Opportunity o = createInMemoryOpportynity(name);
    insert o;
    return o;
  }
}
