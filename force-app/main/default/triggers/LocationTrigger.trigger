trigger LocationTrigger on  Location__c(before insert, after insert, before update, after update) {
    
    LocationTriggerHandler handler = new LocationTriggerHandler();

    if(Trigger.isBefore && Trigger.isInsert){
        handler.beforeInsert(Trigger.new);

    }else if(Trigger.isBefore && Trigger.isUpdate){
        handler.updateStatusDate(Trigger.new, Trigger.oldMap);

    }else if(Trigger.isAfter && Trigger.isUpdate){
        handler.updatePersonStatus(Trigger.new, Trigger.oldMap);

    }

    

}