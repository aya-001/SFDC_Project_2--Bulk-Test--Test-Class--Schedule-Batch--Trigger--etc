public with sharing class PeopleTracingTriggerHandler {
    
    public void checkDuplicate(List<People_Tracing__c> newList){
       
        //duplicate list of People Tracing
        List<People_Tracing__c> duplicatePeopleTrace = CTPeopleTracingController.checkDuplicates(newList);
        
        //add error
       for(People_Tracing__c trace :duplicatePeopleTrace){
         trace.addError('Duplicate record found. Person1:' + trace.Person_1__c + 'Person2:'+ trace.Person_2__c);
        }
    }   
}
