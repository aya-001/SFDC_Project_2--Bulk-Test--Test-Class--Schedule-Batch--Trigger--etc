trigger ContactTrigger on Contact (after insert, after update, after delete) {

    ContactTriggerHandler handler = new ContactTriggerHandler();//instance

    if(Trigger.isAfter && Trigger.isInsert || Trigger.isAfter && Trigger.isUpdate){
        handler.countContact(Trigger.new);
    }else if(Trigger.isAfter && Trigger.isDelete){
        handler.countContact(Trigger.old);
    }
}