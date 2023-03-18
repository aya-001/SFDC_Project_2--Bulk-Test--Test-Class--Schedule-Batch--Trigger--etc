public with sharing class PersonTriggerHandler {
    

    public void personTokenUpdate(List<Person__c> newList){
        // Before insert operation for Person__c object
        // make sure the health status is green
        // generate unique token for each record

        for(Person__c po : newList){
            //update status to Green
            po.Health_Status__c = 'Green';
            //generate unique token
            po.Token__c = CTPersonController.getToken(po.Mobile__c);
           
            }
        }


        public void personHealthUpdate(List<Person__c> newList, Map<Id,Person__c> oldMap){

            //Map to update Person record
            Map<Id, Person__c> dateUpdateHealth = new Map<Id, Person__c>();
    
            //if old Status was differnt from new Status,put in the map
            for(Person__c po : newList){
                if(po.Health_Status__c != oldMap.get(po.Id).Health_Status__c){
                    //check if status is changed
                    //then, update Status_Update_Date__c
                    
                   po.Status_Update_Date__c = Date.today();
                    
                }
            }



    }
}
