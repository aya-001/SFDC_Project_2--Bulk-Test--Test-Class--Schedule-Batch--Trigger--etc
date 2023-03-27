public with sharing class CTDataCleanUpSchedule implements Schedulable {
    public static final String CRON = '0 0 2 * * ?'; //0second 0 minite 2o'clock Everyday Every Month

    public void execute(SchedulableContext sc){
        //instance of Bach Class
        CTPeopleTracingDataCleaUpBatch peopleTracingBatch = new CTPeopleTracingDataCleaUpBatch();
        //Scheduling
        Database.executeBatch(peopleTracingBatch, 2000);


        //instance of location Batch Class
        CTLocationTracingDataCleaUpBatch locationTracingBatch = new CTLocationTracingDataCleaUpBatch();
        //scheduling
        Database.executeBatch(locationTracingBatch, 2000);

        //update person Status
        CTUpdatePersonStatusBatch updatePersonStatus = new CTUpdatePersonStatusBatch();
        Database.executeBatch(updatePersonStatus, 2000);

        //update location Status
        CTUpdateLocationStatusBatch updateLocationStatus = new CTUpdateLocationStatusBatch();
        Database.executeBatch(updateLocationStatus, 2000);
    }
}