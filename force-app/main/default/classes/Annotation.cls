public class Annotation {

    //call from process buildetr
    @InvocableMethod
    public static void justAnnotationMethod() {
        System.debug('Call me from process builder');

    }
}