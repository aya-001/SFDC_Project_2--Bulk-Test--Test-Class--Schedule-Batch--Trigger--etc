public with sharing class CTHealthController {

    //return count of people in each health status
    @AuraEnabled
    public static Map<String, Integer> getPersonHealthStatusCount() {
       
        return CTPersonController.getHealthStatusCount();
    }

    //return count of locations in each health status
    @AuraEnabled
    public static Map<String, Integer> getLocationHealthStatusCount() {
        return CTLocationController.getLocationHealthStatusCount();
    }


}