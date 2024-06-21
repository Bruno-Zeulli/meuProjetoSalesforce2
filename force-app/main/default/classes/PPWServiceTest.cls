@isTest
public class PPWServiceTest {
  @testSetup
    static void setup(){
        List<ExternalAPI__c> apis = new List<ExternalAPI__c>();

           ExternalAPI__c apiBuscarEmpresas = new ExternalAPI__c(
            Name = 'BuscarEmpresaParceiro',
            Endpoint__c = 'https://gateway-sf.azurewebsites.net',
            ComplementUrl__c = '/AmbienteCorporativoExterior/api-gup-hml/api/v1//comissionado/usuario/'
        );


        ExternalAPI__c apippwtoken = new ExternalAPI__c(
            Name = 'PPWToken',
            GrantType__c = 'password',
            ClientID__c = 'parceiros',
            ClientSecret__c = '123',
            Scope__c = 'offline_access',
            Endpoint__c = 'https://gateway-sf.azurewebsites.net',
            ContentType__c = 'application/json',
            ComplementUrl__c = '/api-sso-hml//connect/token',
            User__c = 'Test',
            Password__c = '123'
        );

          apis.add(apiBuscarEmpresas);
        apis.add(apippwtoken);

        insert apis;
    }

    @isTest
    public static void callBuscarEmpresasSuccess(){
        Test.setMock(HttpCalloutMock.class, new MockWebserviceCallsTest.CallBuscarEmpresasSucess());
        Test.startTest();
        String results = PPWController.getInformationPPW();
        Test.stopTest();
        System.debug('rs+'+results);
        system.assert(results != null, true);
    }
}