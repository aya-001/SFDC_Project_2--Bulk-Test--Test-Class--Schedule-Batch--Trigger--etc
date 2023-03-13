public with sharing class CTPersonController {
    
    //Accept a Mobile Number(String)
    //Generate a secure token
    //Retuen the secure token back to caller
    public static String getToken(String PhoneNumber){

        Blob value = Blob.valueOf(PhoneNumber);
        Blob hash = Crypto.generateDigest('MD5',value);
        
        //Change the data type to String fromBlob & return
        return EncodingUtil.base64Encode(hash);
    }


    //Get 100 contacts with recent health status change
    public static List<Person__c> getRecentHealthChanges(){
        List<Person__c> statusPerson = 
            [SELECT Health_Status__c, Mobile__c, Name, OwnerId, Status_Update_Date__c, Token__c FROM Person__c  ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100];

        return statusPerson;
    }


    // Search a person by name, token or mobile
    public static List<Person__c> searchPeople(String searchTerm){

        //Dynamic Query
        String srchWords = '%' + searchTerm + '%';
        
        return [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c
            FROM Person__c
            WHERE Name LIKE :searchTerm
                OR Mobile__c LIKE :searchTerm
                OR Token__c LIKE :searchTerm
            ORDER BY Status_Update_Date__c DESC NULLS LAST];
    }

    
    //Search a person by id
    public static Person__c getPersoncById(String PersonId){

        //Select 1 record from Person__c Object
        Person__c recordPerson = [SELECT Health_Status__c, Mobile__c, Name, OwnerId, Status_Update_Date__c, Token__c FROM Person__c WHERE Id =:PersonId LIMIT 1];
        
        if(recordPerson != null){
            return recordPerson;
        }
        return recordPerson;
    } 
    
}