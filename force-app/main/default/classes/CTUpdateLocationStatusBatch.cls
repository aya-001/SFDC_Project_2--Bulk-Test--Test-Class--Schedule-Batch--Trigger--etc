public with sharing class CTUpdateLocationStatusBatch implements Database.Batchable<SObject>{
    public Database.QueryLocator start(Database.BatchableContext bc){
       
        //List to filter by Type of Status
        List<String> status = new List<String>{'Yellow', 'Orange', 'Red'};
        
        //Variable to define 14days
        Date today = Date.today();
        Date fourteenDaysAgo = today - 14;

        return Database.getQueryLocator('SELECT Id FROM Location__c WHERE Status_Update_Date__c = :fourteenDaysAgo AND Status__c IN: status');
    }

    
    public void execute(Database.BatchableContext bc, List<Location__c> scope){
        for(Location__c location : scope){
            location.Status__c = 'Green';
        }

        update scope;
    }
    
    public void finish(Database.BatchableContext bc){
        System.debug('Batch is completed');

    }
}