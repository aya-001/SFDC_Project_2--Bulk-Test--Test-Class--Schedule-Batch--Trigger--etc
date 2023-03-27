public with sharing class CTLocationController {
    
    public static List<Location__c> getRecentStatusChanges(){
        List<Location__c> location = 
        [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c 
            FROM Location__c 
            ORDER BY Status_Update_Date__c DESC NULLS LAST 
            LIMIT 100];
        
        return location;
    }


     public static List<Location__c> searchLocations(String searchTerm){

        searchTerm = '%' + searchTerm + '%';
        List<Location__c> searchLocation = 
            [SELECT Address__c, CreatedById, Name,OwnerId,Pincode__c,Red_Score__c,Status__c,Status_Update_Date__c  
            FROM Location__c 
            WHERE Name LIKE :searchTerm
            OR Pincode__c LIKE :searchTerm
            OR Address__c LIKE :searchTerm
            OR Status__c LIKE :searchTerm
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

    public static void updateRedscore(Set<Id> locationIds){

        List<Location__c> locationToUpdate =  new List<Location__c>();
        
        AggregateResult[] redHealthStatusLocation = 
            [SELECT COUNT(Id) co, Location__c 
            FROM Location_Tracing__c
            WHERE Visit_Date__c =  LAST_N_DAYS :10
            AND Location__c IN:locationIds
            AND Person__r.Health_Status__c = 'Red'
            GROUP BY Location__c ];

            for(AggregateResult ag : redHealthStatusLocation){
                String locationId = String.valueOf(ag.get('Location__c'));
                Integer redScore = Integer.valueOf(ag.get('co'));
                String status = getStatus(redScore);
                locationToUpdate.add(new Location__c(Id= locationId, 	Red_Score__c= redscore, Status__c= status));
            }

            if(locationToUpdate != null && locationToUpdate.size() > 0){
                update locationToUpdate;
            }
            
    }


    public static String getStatus(Integer redScore){
        if(redScore == 0){
            return 'Green';
        }else if(redScore <= 5){
            return 'Yellow';
        }else if(redScore <= 10){
            return 'Orange';
        }else{
            return 'Red';
        }

    }

    public static Map<String, Integer> getStatusCount(){
        Aggregateresult[] grouoAggregate =
            [SELECT COUNT(Address__c) co,Status__c FROM Location__c 
            GROUP BY Status__c];

            //to count the number of lovation depending on the sheath tatus
            Map<String, Integer> countLocationMap = new Map<String, Integer>();
            
            for(Aggregateresult agg: grouoAggregate){
                String healthStatus = String.valueOf(agg.get('Status__c'));
                Integer numberOfLOcation = Integer.valueOf(agg.get('co'));
                countLocationMap.put(healthStatus,numberOfLOcation);
            }
            
            
            return countLocationMap;
    }

    public static Map<String, Integer> getLocationHealthStatusCount() {
        
        AggregateResult[] countLocationStatus =
        [SELECT COUNT(Id) co, Status__c FROM Location__c GROUP BY Status__c];

        if(countLocationStatus != null && countLocationStatus.size() >0){
            //put status & number of location into Map
            Map<String, Integer> countLocationMap = new Map<String, Integer>();
            for(AggregateResult ag :countLocationStatus){
                countLocationMap.put(String.valueOf(ag.get('Status__c')), Integer.valueOf(ag.get('co')));
            }
            return countLocationMap;  
        }
        return null;
    }

    
}