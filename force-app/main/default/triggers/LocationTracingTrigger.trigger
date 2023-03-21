trigger LocationTracingTrigger on Location_Tracing__c (before insert) {

    LocationTracingTriggerHandler handler = new LocationTracingTriggerHandler();

    if(Trigger.isBefore && Trigger.isInsert){
        handler.checkDuplicate(Trigger.new);

    }

}