trigger ContactTrigger on Contact (after insert, after update, after delete, after undelete) {

    ContactTriggerHandler handler = new ContactTriggerHandler();//instance

    if(Trigger.isAfter && Trigger.isInsert || Trigger.isAfter && Trigger.isUpdate ||Trigger.isAfter && Trigger.isUndelete){
        handler.countContact(Trigger.new);
    }else if(Trigger.isAfter && Trigger.isDelete){
        handler.countContact(Trigger.old);
    }
}

    /* insteas of Trigger.isAfter && Trigger.isInsert  etc,
        switch on Trigger.operationType {
        when AFTER_INSERT {
            for(Contact con : Trigger.new){ ~  alsp wprks 
     */