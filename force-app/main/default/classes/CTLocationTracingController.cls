public with sharing class CTLocationTracingController {
    
  
    /**
     * Get last 30 days visitors
     */
    public static List<Location_Tracing__c> getVistors(String locationId){
        return [SELECT Id, Person__c, Location__c, Visit_Date__c, Person__r.Token__c, Person__r.Health_Status__c 
                    FROM Location_Tracing__c 
                    WHERE Id =: locationId
                    ORDER BY Visit_Date__c DESC ];
    }

    /**
     * Get all location ids for visitors
     */
    public static List<Location_Tracing__c> getLocationsByPersonIds(Set<Id> personIds){
        return [SELECT Id, Person__c, Location__c 
                FROM Location_Tracing__c 
                WHERE Person__c IN :personIds
                AND Visit_Date__c = LAST_N_DAYS:10];
    }

    /**
     * Get all visitor ids for locations
     */
    public static List<Location_Tracing__c> getLocationsByLocationIds(Set<Id> locationIds){
        return [SELECT Id, Person__c, Location__c 
                FROM Location_Tracing__c 
                WHERE Location__c IN :locationIds
                AND Person__r.Health_Status__c = 'Green'
                AND Visit_Date__c = LAST_N_DAYS:10];
    }

    //check ducplicated records
    public static List<Location_Tracing__c> checkDuplicates(List<Location_Tracing__c> newlocationTraces){
        
        //store unique location Ids
        Set<Id> locationIds = new Set<Id>();
        //store unique person Ids
        Set<Id> personIds = new Set<Id>();

        for(Location_Tracing__c dup :newlocationTraces){
            locationIds.add(dup.Location__c);
            personIds.add(dup.Person__c);
        }

        //map of location id, & set of person id
        Map<Id, Set<Id>> mapExistingRecords = new Map<Id, Set<Id>>();

        //query existing location tracing records
        List<Location_Tracing__c> existingRecords =
            [SELECT Id, Person__c, Location__c 
            FROM Location_Tracing__c
            WHERE Location__c IN : locationIds
            AND Person__c IN :personIds];
 
        //list of duplicate records
        List<Location_Tracing__c> duplicate = new List<Location_Tracing__c>();

        if(existingRecords != null && existingRecords.size() >0){
            for(Location_Tracing__c trace :existingRecords){
                if(! mapExistingRecords.containsKey(trace.Location__c)){
                    mapExistingRecords.put(trace.Location__c, new Set<Id>());
                }
                //add person ids to map set
                mapExistingRecords.get(trace.Location__c).add(trace.Person__c);
            }
            //loop over new location tracing records
            for(Location_Tracing__c trace2 :newlocationTraces){
                //first check for location id
                //if item found in map, then check for person in set(locatiob id, person id both)
                if(mapExistingRecords.containsKey(trace2.Location__c)
                    && mapExistingRecords.get(trace2.Location__c).contains(trace2.Person__c)){
                        duplicate.add(trace2);
                }
            }          
        }
        return duplicate;
    }
}