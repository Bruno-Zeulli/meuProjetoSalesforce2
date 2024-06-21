@IsTest
public class HttpUtilTest {

    @IsTest
    static void constructorTest(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallGenericSuccess());

        Test.startTest();
            HttpUtil httpUtil = new HttpUtil('', 'POST');
            httpUtil.setRequestBody('body');
            httpUtil.addHeader('key', 'value');
            httpUtil.buildRequest();
            httpUtil.sendRequest();
        Test.stopTest();

        Assert.areEqual(
            httpUtil.getStatusCode(),
            201,
            'O código da resposta deve ser igual a 201.'
        );

        Assert.areEqual(
            httpUtil.getResponseBody(),
            '',
            'O corpo da resposta retornado deve ser igual a \'\'.'
        );
    }
}