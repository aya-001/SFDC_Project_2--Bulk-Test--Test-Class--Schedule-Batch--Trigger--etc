public with sharing class LocationTracingTriggerHandler {
    
    public void checkDuplicate(List<Location_Tracing__c> newList){
        //put duplicate records list
       List<Location_Tracing__c> duplicateLocationTrace = CTLocationTracingController.checkDuplicates(newList);
        
       //add Error
       for(Location_Tracing__c dup: duplicateLocationTrace){
            dup.addError('Duplicate record found');
        }
    }

}