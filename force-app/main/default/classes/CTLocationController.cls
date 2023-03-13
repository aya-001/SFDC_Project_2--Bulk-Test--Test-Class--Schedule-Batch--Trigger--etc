public with sharing class CTLocationController {
  
    public static List<Location__c> getRecentStatusChanges(){
        List<Location__c> location = 
            [SELECT Address__c, CreatedById, Name,OwnerId,Pincode__c,Red_Score__c,Status__c,Status_Update_Date__c  
            FROM Location__c 
            ORDER BY Status_Update_Date__c DESC
            LIMIT 100];
        
        return location;
    }


     public static List<Location__c> searchLocations(String searchTerm){

        String srchLTerm = '%' + searchTerm + '%';
        List<Location__c> searchLocation = 
            [SELECT Address__c, CreatedById, Name,OwnerId,Pincode__c,Red_Score__c,Status__c,Status_Update_Date__c  
            FROM Location__c 
            WHERE Name LIKE :srchLTerm
            OR Pincode__c LIKE :srchLTerm
            OR Address__c LIKE :srchLTerm
            ORDER BY Status_Update_Date__c DESC NULLS LAST];

        return searchLocation;
    } 


    public static Location__c getLocationById(String locationId){
        Location__c recordLocation =  [SELECT Address__c, CreatedById, Name,OwnerId,Pincode__c,Red_Score__c,Status__c,Status_Update_Date__c  
        FROM Location__c 
        WHERE Id =: locationId
        ORDER BY Status_Update_Date__c DESC
        LIMIT 1];

        return recordLocation;
    }
}