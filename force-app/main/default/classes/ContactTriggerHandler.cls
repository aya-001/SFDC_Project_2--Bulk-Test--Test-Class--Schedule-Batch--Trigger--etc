//Count the number of Contact that has "Active checkbox field
//Account has a number field "Active Contact" which is caluculated
//depending on the related Contact records

public with sharing class ContactTriggerHandler {
    
    public void countContact(List<Contact> newList){

        //Map for caluculating contact number,update Account
        Map<Id, Account> accountUpdate = new Map<Id, Account>();

        //add 0 as initial number
        for(Contact con : newList){
            Account ac = new Account(Id = con.AccountId, Active_Contacts__c = 0);
                accountUpdate.put(con.AccountId, ac);
           
        }
        System.debug('after putting 0');

        List<AggregateResult> results = 
            [SELECT COUNT(Id) co, AccountId FROM Contact WHERE Active__c = TRUE GROUP BY AccountId];

            System.debug('AggregatreResult' + results);

        for(AggregateResult rslt :results ){
            Id accId = (Id)rslt.get('AccountId');
            Account aa = new Account(Id = accId, Active_Contacts__c = (Integer)rslt.get('co') );

            // instead of ()Id →　String.valueOf(result.get('AccountId'));　is good as well

            accountUpdate.put(accId , aa);
        }

        try {
            update accountUpdate.values();

        }catch(ListException e){
            System.debug(e.getMessage());
        }
    }
}
