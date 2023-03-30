@isTest
public class FitnessTest {

    @isTest
    public static void FitnessTest1() {

        //call caluculateBMI method
        Decimal result = Fitness.caluculateBMI(46.2, 1.52);
        result = result.setScale(2);
        System.assertEquals(20.00, result, 'BMI should be 20.12');
    }

    @isTest
    public static void FitnessTest2() {

        //call caluculateBMI method
        Decimal result = Fitness.caluculateBMI(0, 1.52);

        System.assertEquals(0, result, 'BMI should be 20.12');
    }

    @isTest
    public static void FitnessTest3() {

        //call caluculateBMI method
        Decimal result = Fitness.caluculateBMI(-46.2, 0);

        System.assertEquals(-1, result, 'BMI should be 20.12');
    }

    @isTest
    public static void FitnessTest4() {

        //call caluculateBMI method
        Decimal result = Fitness.caluculateBMI(46.2, -1.52);

        System.assertEquals(-1, result, 'BMI should be 20.12');
    }



    @isTest
    public static void calculatePaceTest1(){
        Decimal distance = 10;
        Decimal minutes = 60;

        Decimal result = Fitness.calculatePace(distance, minutes);
        System.assertEquals(10, result, 'Pace should 10km/hr for 10 km in 60 minutes');
    }

    @isTest
    public static void calculatePaceTest2(){
        Decimal distance = 10;
        Decimal minutes = 0;

        Decimal result = Fitness.calculatePace(distance, minutes);
        System.assertEquals(-1, result, 'Invalid input');
    }

    @isTest
    public static void calculatePaceTest3(){
        Decimal distance = 0;
        Decimal minutes = 60;

        Decimal result = Fitness.calculatePace(distance, minutes);
        System.assertEquals(0, result, 'Pace should 0km/hr for 0 km in 60 minutes');
    }

    @isTest
    public static void calculatePaceTest4(){
        Decimal distance = -10;
        Decimal minutes = 60;

        Decimal result = Fitness.calculatePace(distance, minutes);
        System.assertEquals(-1, result, 'Invalid input');
    }

    @isTest
    public static void calculatePaceTest5(){
        Decimal distance = 10;
        Decimal minutes = -60;

        Decimal result = Fitness.calculatePace(distance, minutes);
        System.assertEquals(-1, result, 'Invalid input');
    }

}