public with sharing class CTRecentChangesController {
    
    //return people details sorted by status updated date in descending order
    @AuraEnabled
    public static List<Person__c> getRecentPersonHealthChanges(){
        return CTPersonController.getRecentHealthChanges();
    }

    //return location details sorted by status updated date in descending order
    @AuraEnabled
    public static List<Location__c> getRecentLocationHealthChanges(){
        return CTLocationController.getRecentStatusChanges();
    }

    //return people matching a search term
    @AuraEnabled
    public static List<Person__c> searchPeople(String searchTerm){
        return CTPersonController.searchPeople(searchTerm);

    }

    //return location matching a search term
    @AuraEnabled
    public static List<Location__c> searchLocations(String searchTerm){
        return CTLocationController.searchLocations(searchTerm);
    }


}