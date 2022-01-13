trigger OpportunityTrigger on Opportunity(after update) {
  for (Opportunity a : Trigger.new) {
    Opportunity b = Trigger.oldMap.get(a.Id);
    if (
      a.RecordTypeId == '0124T000000LpApQAK' &&
      (b.StageName != 'Closed - Lost' &&
      a.StageName == 'Closed - Lost')
    ) {
      OrderController.cancelOrder(a.Id);
    }
  }
}
