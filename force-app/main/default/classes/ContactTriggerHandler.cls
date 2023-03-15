public with sharing class ContactTriggerHandler {
    
    public void countContact(List<Contact> newList){

        //Map for caluculating contact number,update Account
        Map<Id, Account> accountUpdate = new Map<Id, Account>();

        //add 0 as initial number
        for(Contact con : newList){
            if(con.Active__c == true){
                Account ac = new Account(Id = con.AccountId, Active_Contacts__c = 0);
                accountUpdate.put(con.AccountId, ac);
            }
        }

        List<AggregateResult> results = 
            [SELECT COUNT(Id) co, AccountId FROM Contact WHERE Active__c = true GROUP BY AccountId];

        for(AggregateResult rslt :results ){
            Id accId = (Id)rslt.get('AccountId');
            Account aa = new Account(Id = accId, Active_Contacts__c = (Integer)rslt.get('co') );

            accountUpdate.put(accId , aa);
        }

        update accountUpdate.values();
    }
}
