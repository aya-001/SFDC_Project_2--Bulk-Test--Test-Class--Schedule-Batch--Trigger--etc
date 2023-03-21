trigger PersonTrigger on Person__c (after insert, after update) {

    PersonTriggerHandler handler = new PersonTriggerHandler();

    if(Trigger.isBefore && Trigger.isInsert){
        handler.personTokenUpdate(Trigger.new);

    }else if(Trigger.isBefore && Trigger.isUpdate){
        handler.personHealthUpdate(Trigger.new, Trigger.oldMap);
    }else if(Trigger.isAfter && Trigger.isUpdate){
        handler.afterUpdate(Trigger.new, Trigger.oldMap);

    }

    
}