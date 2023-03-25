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
        [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
            FROM Person__c 
            ORDER BY Status_Update_Date__c DESC NULLS LAST 
            LIMIT 100];

        return statusPerson;
    }


    // Search a person by name, token or mobile
    public static List<Person__c> searchPeople(String searchTerm){

        //Dynamic Query
        searchTerm = '%' + searchTerm + '%';
        
        return [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c
             FROM Person__c
            WHERE Name LIKE :searchTerm
                OR Mobile__c LIKE :searchTerm
                OR Token__c LIKE :searchTerm
            ORDER BY Status_Update_Date__c DESC NULLS LAST ];
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


    //count the number of peope depending on the health conditions
    public static Map<String, Integer> getHealthStatusCount(){
        AggregateResult[] groupAggregate = 
        [SELECT COUNT(Id) co, Health_Status__c 
        FROM Person__c
        GROUP BY Health_Status__c];


        //to put the number of people depending on the health condition
        Map<String, Integer> numPeopleMap = new Map<String, Integer>();

        for(Aggregateresult agg :groupAggregate){

            //Cast datatype of AggregateResult
            String healthStatus = String.valueOf(agg.get('Health_Status__c'));
            Integer count = Integer.valueOf(agg.get('co'));

            //out in map
            numPeopleMap.put(healthStatus, count);
        }
        return numPeopleMap;
    }



    //⓵Mark all people 'Cohabitants' Orange -
    //Except the Red /Orange one
    public static Set<Id> getCohanitants(Set<Id> personIds, Set<Id> alreadyProcessedIds){
        //avoid Red, Orange
        List<String> healthStatus = new List<String> {'Green', 'Yellow'};
        
        //Query person Id
        //whose Contact_Type__c is 'Cohabitant'
        List<People_Tracing__c> peopleTraces =
        [SELECT Id, Person_1__c, Person_2__c 
            FROM People_Tracing__c
            WHERE (Person_1__c IN :personIds OR Person_2__c IN :personIds)
            AND Contact_Type__c = 'Cohabitant'
            AND  (Person_1__r.Health_Status__c IN :healthStatus OR Person_2__r.Health_Status__c IN :healthStatus)];
    

        //put person's Id who is not in the personIds to Map
        //same person can't be cohabitant by himself
        Set<Id> cohabitants = new  Set<Id> ();
        for(People_Tracing__c po :peopleTraces){
            if(!alreadyProcessedIds.contains(po.Person_1__c)){
                cohabitants.add(po.Person_1__c);
                alreadyProcessedIds.add(po.Person_1__c);
            }
            if(!alreadyProcessedIds.contains(po.Person_2__c)){
                cohabitants.add(po.Person_2__c);
                alreadyProcessedIds.add(po.Person_2__c);
            }
        }


        return cohabitants;
        }


    //⓶Mark all people 'Neighbors' Yellow -
    //Except the Red /Orange one
    public static Set<Id> getNeighbours(Set<Id> personIds, Set<Id> alreadyProcessedIds){
       
        //Query person Id
        //whose Contact_Type__c is 'Neighbors'
        List<People_Tracing__c> peopleTraces =
        [SELECT Id, Person_1__c, Person_2__c 
            FROM People_Tracing__c
            WHERE (Person_1__c IN :personIds OR Person_2__c IN :personIds)
            AND Contact_Type__c = 'Neighbour'
            AND  (Person_1__r.Health_Status__c = 'Green' OR Person_2__r.Health_Status__c = 'Green')];
    

        //put person's Id who is not in the personIds to Map
        //same person can't be cohabitant by himself
        Set<Id> neighbours = new  Set<Id> ();
        for(People_Tracing__c po :peopleTraces){
            if(!alreadyProcessedIds.contains(po.Person_1__c)){
                neighbours.add(po.Person_1__c);
                alreadyProcessedIds.add(po.Person_1__c);
            }
            if(!alreadyProcessedIds.contains(po.Person_2__c)){
                neighbours.add(po.Person_2__c);
                alreadyProcessedIds.add(po.Person_2__c);
            }
        }
        


        return neighbours;
    }


    //⓷Mark all people 'primaryContacts'  Orange -
    //Except the Red /Orange one
    public static Set<Id> getPrimaryContacts(Set<Id> personIds, Set<Id> alreadyProcessedIds){
       
        //avoid Red, Orange
        List<String> healthStatus = new List<String> {'Green', 'Yellow'};

        //Query person Id
        //whose Contact_Type__c is 'Other'
        List<People_Tracing__c> peopleTraces =
        [SELECT Id, Person_1__c, Person_2__c 
            FROM People_Tracing__c
            WHERE (Person_1__c IN :personIds OR Person_2__c IN :personIds)
            AND Contact_Type__c = 'Others'
            AND Contact_Date__c = LAST_N_DAYS:10
            AND  (Person_1__r.Health_Status__c IN: healthStatus OR Person_2__r.Health_Status__c IN: healthStatus)];
    

        //put person's Id who is not in the personIds to Map
        //same person can't be cohabitant by himself
        Set<Id> primaryContacts = new  Set<Id> ();
        for(People_Tracing__c po :peopleTraces){
            if(!alreadyProcessedIds.contains(po.Person_1__c)){
                primaryContacts.add(po.Person_1__c);
                alreadyProcessedIds.add(po.Person_1__c);
            }
            if(!alreadyProcessedIds.contains(po.Person_2__c)){
                primaryContacts.add(po.Person_2__c);
                alreadyProcessedIds.add(po.Person_2__c);
            }
        }


        return primaryContacts;
    }


     //⓸Mark all people 'SecondaryContacts'  Yellow -
    //Except the Red /Orange one
    public static Set<Id> getSecondaryContacts(Set<Id> primaryContactIds, Set<Id> alreadyProcessedIds){
       
        //Query person Id
        //whose Contact_Type__c is 'Other'
        List<People_Tracing__c> peopleTraces =
        [SELECT Id, Person_1__c, Person_2__c 
            FROM People_Tracing__c
            WHERE (Person_1__c IN :primaryContactIds OR Person_2__c IN :primaryContactIds)
            AND Contact_Type__c = 'Others'
            AND Contact_Date__c = LAST_N_DAYS:10
            AND  (Person_1__r.Health_Status__c = 'Green' OR Person_2__r.Health_Status__c = 'Green')];
    

        //put person's Id who is not in the personIds to Map
        //same person can't be cohabitant by himself
        Set<Id> secondaryContacts = new  Set<Id> ();
        for(People_Tracing__c po :peopleTraces){
            if(!alreadyProcessedIds.contains(po.Person_1__c)){
                secondaryContacts.add(po.Person_1__c);
                alreadyProcessedIds.add(po.Person_1__c);
            }
            if(!alreadyProcessedIds.contains(po.Person_2__c)){
                secondaryContacts.add(po.Person_2__c);
                alreadyProcessedIds.add(po.Person_2__c);
            }
        }


        return secondaryContacts;
    }


    public static Map<String, Integer> getPersonHealthStatusCount() {
        AggregateResult[] countPeopleStatus =
        [SELECT COUNT(Id) co, Health_Status__c FROM Person__c GROUP BY Health_Status__c ];
        
        if(countPeopleStatus != null && countPeopleStatus.size() > 0){
            //put status, & number of count into Map
            Map<String, Integer> countPersonMap = new Map<String, Integer>();
            
            for(AggregateResult ag :countPeopleStatus){
                countPersonMap.put(String.valueOf(ag.get('Health_Status__c')),Integer.valueOf(ag.get('co')));
            }  
            return countPersonMap;
        }
        return null;
    }
    
}