public with sharing class LocationTriggerHandler {
    
    //when location status is Green
    //if location status changes, update Status Update Date
        public void beforeInsert(List<Location__c> newList){
            for(Location__c loc :newList){
                loc.Status__c = 'Green';
            }
        }

        public void updateStatusDate(List<Location__c> newList, Map<Id, Location__c> oldMap){
            
            for(Location__c loc :newList){
                if(loc.Status__c != oldMap.get(loc.Id).Status__c){
                    loc.Status_Update_Date__c = Date.today();
                }
            }
        }

        public void updatePersonStatus(List<Location__c> newList, Map<Id, Location__c> oldMap){

            //put location where location's status begomes Red
            //to change person's Status, who visited the location witin 10 days
            Set<Id> locationRedIds = new Set<Id>();

            for(Location__c loc : newList){
                if(loc.Status__c == 'Red' && oldMap.get(loc.Id).Status__c != 'Red'){
                    locationRedIds.add(loc.Id);
                }
            }

            //query person to update
            List<Location_Tracing__c> personToStatusUpdate = CTLocationTracingController.getLocationsByLocationIds(locationRedIds);
            
            //to put personId for update healthDtatus
            Set<Id> personIds = new Set<Id>();
            for(Location_Tracing__c  pe :personToStatusUpdate){
                personIds.add(pe.Person__c);
            }

            //to put personId to update health Status
           List<Person__c> personToUpdate = new List<Person__c>();
            for(Id peid :personIds){
                personToUpdate.add(new Person__c(Id = peid, Health_Status__c = 'Yellow'));
            }

            if(personToUpdate.size() > 0){
                update personToUpdate;
            }
            
        }
}