trigger PeopeTracingTrigger on People_Tracing__c (before insert, after insert) {
    PeopleTracingTriggerHandler handler = new PeopleTracingTriggerHandler();

    if(Trigger.isBefore && Trigger.isInsert){
        handler.checkDuplicate(Trigger.new);

    }
    
}