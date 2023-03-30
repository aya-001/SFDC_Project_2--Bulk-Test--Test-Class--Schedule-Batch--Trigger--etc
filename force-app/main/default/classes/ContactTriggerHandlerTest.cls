@isTest
public with sharing class ContactTriggerHandlerTest {
    
    @isTest
    public static void countContactTest(){
        List<Account> testAccounts = new List<Account>();
        testAccounts.add(new Account(Name = 'Test 1'));
        testAccounts.add(new Account(Name = 'Test 2'));
        testAccounts.add(new Account(Name = 'Test 3'));

        insert testAccounts;

        List<Contact> testContacts = new List<Contact>();
        testContacts.add(new Contact(LastName = 'test Contact 1', AccountId = testAccounts[0].Id));
        testContacts.add(new Contact(LastName = 'test Contact 2', AccountId = testAccounts[0].Id));
        testContacts.add(new Contact(LastName = 'test Contact 3', AccountId = testAccounts[0].Id));

        insert testContacts;

        List<Account> acc = [SELECT Id, Active_Contacts__c FROM Account];
        System.assertEquals(2,acc.size());
        System.assertEquals(null, acc[0].Active_Contacts__c);
        System.assertEquals(null, acc[1].Active_Contacts__c);

        List<Contact> con = [SELECT Id FROM Contact];
        System.assertEquals(5, con.size());

    }


    @isTest
    pubic static void countContactTestBulk(){

        
    }

}
