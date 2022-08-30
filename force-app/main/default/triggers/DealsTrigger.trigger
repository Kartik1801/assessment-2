trigger DealsTrigger on DealC__c (before insert) {
    DealsTriggerHelperClass.mailOnCreation(Trigger.new);   
}