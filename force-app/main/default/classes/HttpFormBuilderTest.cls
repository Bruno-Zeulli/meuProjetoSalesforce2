/**
 * @description       : Constroi o blobBody  para requisições HTTP form-data
 * @author            : marcelomartins@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 11-23-2021
 * @last modified by  : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-23-2021   marcelomartins@wizsolucoes.com.br   Initial Version
 **/
@isTest
public class HttpFormBuilderTest {

    @isTest
    static void shouldReturnContentTypeHeader(){

        Test.startTest();
        String result = HttpFormBuilder.getContentType();
        Test.stopTest();        
        
        String expected = 'multipart/form-data; charset="UTF-8"; boundary="1ff13444ed8140c7a32fc4e6451aa76d"';
        String actual = result;
        System.assertEquals(expected, actual, 'Expected must if ContentType header equals');
    }

    @isTest
    static void shouldReturnStringBody(){
        String key = 'testKey';
        String value = 'testValue';

        Test.startTest();
        String result = HttpFormBuilder.writeStrBodyParameter(key, value);
        Test.stopTest();

        String strBody = 'Content-Disposition: form-data; name="testKey"\r\n\r\ntestValue';

        String expected = strBody;
        String actual = result;
        System.assertEquals(expected, actual, 'Expected not equals value actual');
    }

    @isTest
    static void shouldReturnBodyParameterFile(){
        String key = 'testKey';
        String value = 'testValue';

        Test.startTest();
        String result = HttpFormBuilder.writeBodyParameterFile(key, value);
        Test.stopTest();

        String body = 'Q29udGVudC1EaXNwb3NpdGlvbjogZm9ybS1kYXRhOyBuYW1lPSJ0ZXN0S2V5IiANCg0KdGVzdFZhbHVlIA0K';

        String expected = body;
        String actual = result;
        System.assertEquals(expected, actual, 'Expected not equals value actual');
    }

    @isTest
    static void shouldReturnBodyParameter(){
        String key = 'testKey';
        String value = 'testValue';

        Test.startTest();
        String result = HttpFormBuilder.writeBodyParameter(key, value);
        Test.stopTest();

        String body = 'Q29udGVudC1EaXNwb3NpdGlvbjogZm9ybS1kYXRhOyBuYW1lPSJ0ZXN0S2V5IiANCg0KdGVzdFZhbHVlIA0K';

        String expected = body;
        String actual = result;
        System.assertEquals(expected, actual, 'Expected not equals value actual');
    }

    @isTest
    static void shouldReturnBoundary(){
        Test.startTest();
        String result = HttpFormBuilder.writeBoundary();
        Test.stopTest();

        String body = 'LS0xZmYxMzQ0NGVkODE0MGM3YTMyZmM0ZTY0NTFhYTc2ZA0K';

        String expected = body;
        String actual = result;
        System.assertEquals(expected, actual, 'Expected not equals value actual');
    }

    @isTest
    static void shouldReturnStrBoundary(){
        Test.startTest();
        String result = HttpFormBuilder.WriteStrBoundary();
        Test.stopTest();

        String body = '--1ff13444ed8140c7a32fc4e6451aa76d\r\n';

        String expected = body;
        String actual = result;
        System.assertEquals(expected, actual, 'Expected not equals value actual');
    }

    @isTest
    static void shouldReturnBoundaryEnd(){
        Test.startTest();
        String result1 = HttpFormBuilder.writeBoundary(HttpFormBuilder.EndingType.CrLf);
        String result2 = HttpFormBuilder.writeBoundary(HttpFormBuilder.EndingType.Cr);
        String result3 = HttpFormBuilder.writeBoundary(HttpFormBuilder.EndingType.None);
        Test.stopTest();

        String body1 = 'LS0xZmYxMzQ0NGVkODE0MGM3YTMyZmM0ZTY0NTFhYTc2ZC0t';
        String body2 = 'Ci0tMWZmMTM0NDRlZDgxNDBjN2EzMmZjNGU2NDUxYWE3NmQtLQ==';
        String body3 = 'DQotLTFmZjEzNDQ0ZWQ4MTQwYzdhMzJmYzRlNjQ1MWFhNzZkLS0=';

        String expected1 = body1;
        String actual1 = result1;
        String expected2 = body2;
        String actual2 = result2;
        String expected3 = body3;
        String actual3 = result3;

        System.assertEquals(expected1, actual1, 'Expected1 not equals value actual1');
        System.assertEquals(expected2, actual2, 'Expected2 not equals value actual2');
        System.assertEquals(expected3, actual3, 'Expected3 not equals value actual3');

    }
}