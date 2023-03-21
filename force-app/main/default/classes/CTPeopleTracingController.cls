public with sharing class CTPeopleTracingController {
    
    public static List<People_Tracing__c> getTraces(String personId){

        List<People_Tracing__c> tracepple = 
            [SELECT Id,Person_1__r.Health_Status__c, Person_1__r.Token__c,Person_2__r.Health_Status__c, Person_2__r.Token__c,
            IsDeleted, Name, CreatedDate, LastModifiedDate, Contact_Date__c, Contact_Type__c, 
            Person_1__c, Person_2__c 
            FROM People_Tracing__c
            WHERE Person_1__c = :personId
            OR Person_2__c = :personId
            ORDER BY Contact_Date__c DESC];
        return tracepple;
    }


    //chech duplicate records
    public static List<People_Tracing__c> checkDuplicates(List<People_Tracing__c> peopleTraces){

        //store unique Person_1__c Ids
        //store unique Person_2__c Ids
        Set<Id> personIds = new Set<Id>();

        //put Ids from  List<People_Tracing__c> peopleTraces
        for(People_Tracing__c pplTrace : peopleTraces ){
            personIds.add(pplTrace.Person_1__c);
            personIds.add(pplTrace.Person_2__c);
        }

        //map of Person_1__c, set of Person_2__c
        Map<Id, Set<Id>> mapExistingPersonRecords = new Map<Id, Set<Id>>();

        //query existing pereson Tracing records
        List<People_Tracing__c> existingPersons = 
            [SELECT Id, IsDeleted, Name, CreatedDate, LastModifiedDate, Contact_Date__c, Contact_Type__c, Person_1__c, Person_2__c 
            FROM People_Tracing__c
            WHERE Person_1__c IN :personIds
            OR Person_2__c IN :personIds];


            //List of duplicate records
            List<People_Tracing__c> duplicatePersons = new List<People_Tracing__c>();

            if(existingPersons != null && existingPersons.size() >0 ){
                for(People_Tracing__c trace : existingPersons){
                    //build map for person1
                    if(!mapExistingPersonRecords.containsKey(trace.Person_1__c)){
                        mapExistingPersonRecords.put(trace.Person_1__c, new Set<Id>());
                    }
                    //add person ids to map set
                    mapExistingPersonRecords.get(trace.Person_1__c).add(trace.Person_2__c);

                    //build map for person2
                    if(!mapExistingPersonRecords.containsKey(trace.Person_2__c)){
                        mapExistingPersonRecords.put(trace.Person_2__c, new Set<Id>());
                    }
                    //add person ids to map set
                    mapExistingPersonRecords.get(trace.Person_2__c).add(trace.Person_1__c);

                }


                //loop new person tracing records
                for(People_Tracing__c trace2 :peopleTraces){
                    //first check for person1
                    //if item is found in map,then check in set
                    if(
                        (mapExistingPersonRecords.containsKey(trace2.Person_1__c) && mapExistingPersonRecords.get(trace2.Person_1__c).contains(trace2.Person_2__c))
                        ||
                        (mapExistingPersonRecords.containsKey(trace2.Person_2__c) && mapExistingPersonRecords.get(trace2.Person_2__c).contains(trace2.Person_1__c))
                       
                    ){
                        duplicatePersons.add(trace2);
                    }
                }
            }

        return duplicatePersons;


    }
}