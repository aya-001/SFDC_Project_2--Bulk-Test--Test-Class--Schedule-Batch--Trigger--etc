@isTest
public class CountCovidCasesTest {
    
    @isTest
    public static void treatPatientTest(){

        //create instance of the class
        CountCovidCases count = new CountCovidCases(10);

        Integer actualNUmber = count.getTreated();
        //check if the count is 10 or not
        System.assertEquals(10, actualNUmber, 'Treated Count doesnt match ');


        //create instance of the class
        CountCovidCases count2 = new CountCovidCases(112);

        actualNUmber = count2.getTreated();
        //check if the count is 10 or not
        System.assertEquals(112, actualNUmber, 'Treated Count doesnt match ');

        //check the count of recoveredInCountry
        System.assertEquals(122, CountCovidCases.recoveredInCountry,'Treated Count doesnt match' );

        count.treatPatient();
        actualNUmber = count.getTreated();
        System.assert(actualNUmber == 11, 'Treated count doesnt match');
        System.assert(CountCovidCases.recoveredInCountry == 123, 'Treated count doent match');

        
    }

    @isTest
    public static void treatPatientTestNegative(){

        //create instance of the class
        CountCovidCases count = new CountCovidCases(-10);

        Integer actualNUmber = count.getTreated();
        //check if the count is 0 or not
        System.assertEquals(0, actualNUmber, 'Treated Count doesnt match ');

    }



}