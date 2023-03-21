public with sharing class PersonTriggerHandler {
    

    public void personTokenUpdate(List<Person__c> newList){
        // Before insert operation for Person__c object
        // make sure the health status is green
        // generate unique token for each record

        for(Person__c po : newList){
            //update status to Green
            po.Health_Status__c = 'Green';
            //generate unique token
            po.Token__c = CTPersonController.getToken(po.Mobile__c);
           
            }
        }


        public void personHealthUpdate(List<Person__c> newList, Map<Id,Person__c> oldMap){

            //if old Status was differnt from new Status,put in the map
            for(Person__c po : newList){
                if(po.Health_Status__c != oldMap.get(po.Id).Health_Status__c){
                    //check if status is changed
                    //then, update Status_Update_Date__c
                    
                   po.Status_Update_Date__c = Date.today();             
                }
            }
        }


        //after Health Status is changed, Location should aslo be changed
        public void afterUpdate(List<Person__c> newList, Map<Id,Person__c> oldMap){
            //put Id when person's status is changed
            //put Id when person's status is changed to Red
            Set<Id> statusChangeIds = new Set<Id>();
            Set<Id> statusRedIds = new Set<Id>();

            //if old Status was differnt from new Status,put in the map
            for(Person__c po : newList){
                if(po.Health_Status__c != oldMap.get(po.Id).Health_Status__c){
                    //check if status is changed
                    //then, put Id
                    statusChangeIds.add(po.Id);
                }
                if(po.Health_Status__c == 'Red' && oldMap.get(po.Id).Health_Status__c != 'Red'){
                    //check if status is changed
                    //then, put Id
                    statusRedIds.add(po.Id);    
                }
            }

            //put Id when person's status is changed
            //put Id when person's status is changed to Red
            Set<Id> orangeChangeIds = new Set<Id>();
            Set<Id> yellowChangeIds = new Set<Id>();

            //avoid Process again and again
            Set<Id> alreadyProcessedIds = new Set<Id>();
            alreadyProcessedIds.addAll(statusRedIds);

            //to udate RedScore & Status of Location
            List<Person__c> personToUdate = new List<Person__c>();

            //Cohabitants become Orange →　Orange status →put in orangeChangeIds 
            orangeChangeIds .addAll(CTPersonController.getCohanitants(statusRedIds, alreadyProcessedIds));
            //PrimayContacts become Orange →　Orange status →put in orangeChangeIds 
            Set<Id> ptimaryContactIds = CTPersonController.getPrimaryContacts(statusRedIds, alreadyProcessedIds);
            orangeChangeIds .addAll(ptimaryContactIds);

            //Neighcours become Yellow →　v status →put in orangeChangeIds 
            yellowChangeIds .addAll(CTPersonController.getNeighbours(statusRedIds, alreadyProcessedIds));
            //Secondary become Yellow →　Yellow status →put in orangeChangeIds 
            yellowChangeIds .addAll(CTPersonController.getSecondaryContacts(ptimaryContactIds, alreadyProcessedIds));

            for(Id pId :orangeChangeIds){
                personToUdate.add(new Person__c(Id =  pId, Health_Status__c = 'Orange') );
            }

            for(Id pId :yellowChangeIds){
                personToUdate.add(new Person__c(Id =  pId, Health_Status__c = 'Yellow') );
            }

            if(personToUdate.size() >0){
                update personToUdate;
            }


            //get Location_Tracing__c records from personIds
            //get Locations from LLocation_Tracing__c 
            List<Location_Tracing__c> locationTraces = CTLocationTracingController.getLocationsByPersonIds(statusChangeIds);
            if(locationTraces != null && locationTraces.size() > 0){
                // put Location Id to Set<Id>
                Set<Id> locationIds =  new Set<Id>();
                for(Location_Tracing__c trace :locationTraces){
                    locationIds.add(trace.Location__c);

                }
                //call CTLocationController.updateRedscore();
                CTLocationController.updateRedscore(locationIds);
            }
            
        }

}
