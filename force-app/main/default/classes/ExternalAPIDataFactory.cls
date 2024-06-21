/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
 * 1.1   02-11-2022   marcelomartins@wizsolucoes.com.br    Refactore and insert send products to data extension mkt clould
 **/
@isTest
public class ExternalAPIDataFactory {
    public static List<ExternalAPI__c> createExternalAPIs(){
        List<ExternalAPI__c> apis = new List<ExternalAPI__c>();
        ExternalAPI__c sso = new ExternalAPI__c(
            Name = 'SSO',
            GrantType__c = 'client_credentials',
            ClientID__c = '123',
            ClientSecret__c = '123',
            Scope__c = 'test.api.sso',
            Endpoint__c = 'https://sso-hml.azurewebsites.net/connect/token',
            ContentType__c = 'application/x-www-form-urlencoded'
        );
        ExternalAPI__c ssov1 = new ExternalAPI__c(
            Name = 'SSOv1',
            GrantType__c = 'client_credentials',
            ClientID__c = '123',
            ClientSecret__c = '123',
            Scope__c = 'test.api.sso',
            Endpoint__c = 'https://sso-hml.azurewebsites.net/connect/token',
            ContentType__c = 'application/x-www-form-urlencoded'
        );
        ExternalAPI__c cti = new ExternalAPI__c(
            Name = 'CTI',
            GrantType__c = 'client_credentials',
            ClientID__c = '123',
            ClientSecret__c = '123',
            Scope__c = 'test.api.cti',
            Endpoint__c = 'https://api-cti-hml.azurewebsites.net/',
            ContentType__c = 'application/json'
        );
        ExternalAPI__c sipre = new ExternalAPI__c(
            Name = 'SIPRE',
            GrantType__c = 'client_credentials',
            ClientID__c = '123',
            ClientSecret__c = '123',
            Scope__c = 'test.api.sipre',
            Endpoint__c = 'https://gateway-sf.azurewebsites.net/api/sipre/sinistro',
            ContentType__c = 'application/json'
        );
        ExternalAPI__c mac = new ExternalAPI__c(
            Name = 'MAC',
            GrantType__c = 'client_credentials',
            ClientID__c = '123',
            ClientSecret__c = '123',
            Scope__c = 'test.api.mac',
            Endpoint__c = 'https://conciergehabitacional-hml.azurewebsites.net/api/',
            User__c = 'user',
            Password__c = 'password',
            ContentType__c = 'application/json'
        );
        ExternalAPI__c corporativo = new ExternalAPI__c(
            Name = 'Corporativo',
            GrantType__c = 'client_credentials',
            ClientID__c = '123',
            ClientSecret__c = '123',
            Scope__c = 'test.api.corporativo',
            ContentType__c = 'application/json'
        );
        ExternalAPI__c mktCloudAuth = new ExternalAPI__c(
            Name = 'MarketingCloudAuth',
            ClientID__c = '123',
            ClientSecret__c = '123',
            ContentType__c = 'application/json',
            GrantType__c = 'client_credentials',
            EventKey__c = '123',
            Endpoint__c = 'https://qqq.auth.marketingcloudapis.com/v2/token',
            AccessType__c = 'offline'
        );
        ExternalAPI__c mktCloud = new ExternalAPI__c(Name = 'MarketingCloud', Endpoint__c = 'https://www.exacttargetapis.com/interaction/v1/events', EventKey__c = '1234567890');
        ExternalAPI__c mktCloudRCPM = new ExternalAPI__c(
            Name = 'MarketingCloudRCPM',
            Endpoint__c = 'https://www.exacttargetapis.com/interaction/v1/events',
            EventKey__c = '1234567890'
        );
        ExternalAPI__c mktCloudPrestamista = new ExternalAPI__c(
            Name = 'MarketingCloudPrestamista',
            Endpoint__c = 'https://www.exacttargetapis.com/interaction/v1/events',
            EventKey__c = '1234567890'
        );
        ExternalAPI__c mktCloudDataExtentionsProduct = new ExternalAPI__c(
            Name = 'MktCloudDataExtentionsProductCorporate',
            Endpoint__c = 'https://www.exacttargetapis.com/interaction/v1/events',
            EventKey__c = '1234567890'
        );
        ExternalAPI__c mktCloudAgro = new ExternalAPI__c(
            Name = 'MarketingCloudAgro',
            Endpoint__c = 'https://www.exacttargetapis.com/interaction/v1/events',
            EventKey__c = '1234567890'
        );

        ExternalAPI__c mktCloudB2UWpp = new ExternalAPI__c(
            Name = 'MarketingCloudB2UWhatsApp',
            Endpoint__c = 'https://www.exacttargetapis.com/interaction/v1/events',
            EventKey__c = '1234567890'
        );

        ExternalAPI__c diretrix = new ExternalAPI__c(
            Name = 'Diretrix',
            ClientID__c = '7',
            Endpoint__c = 'https://diretrixon.com/diretrixrest/api/wizcorporate/localizadorpj?tipoRetorno=json',
            User__c = 'user',
            Password__c = 'password',
            ContentType__c = 'application/json',
            AccountId__c = 'wiz'
        );

        ExternalAPI__c marketingCloudVIPOpportunity = new ExternalAPI__c(
            Name = 'MarketingCloudVIPOpportunity',
            Endpoint__c = 'https://www.exacttargetapis.com/interaction/v1/events',
            EventKey__c = '1234567890'
        );

        ExternalAPI__c marketingCloudVIPAccount = new ExternalAPI__c(
            Name = 'MarketingCloudVIPAccount',
            Endpoint__c = 'https://www.exacttargetapis.com/interaction/v1/events',
            EventKey__c = '1234567890'
        );
        ExternalAPI__c apiwflow = new ExternalAPI__c(
            Name = 'APIWFlow',
            GrantType__c = 'client_credentials',
            ClientID__c = '123',
            ClientSecret__c = '123',
            Scope__c = 'test.api.apiwflow',
            Endpoint__c = 'https://gateway-sf.azurewebsites.net/api/apiwflow',
            ContentType__c = 'application/json'
        );
        ExternalAPI__c apidocumentos = new ExternalAPI__c(
            Name = 'APIDocumentos',
            GrantType__c = 'client_credentials',
            ClientID__c = '123',
            ClientSecret__c = '123',
            Scope__c = 'test.api.apidocumentos',
            Endpoint__c = 'https://gateway-sf.azurewebsites.net/api/apidocumentos',
            ContentType__c = 'application/json'
        );

        ExternalAPI__c apiSaveDocumentByOpp = new ExternalAPI__c(
            Name = 'SaveDocumentByOpportunity',
            GrantType__c = 'client_credentials',
            ClientID__c = '123',
            ClientSecret__c = '123',
            Scope__c = 'test.api.apidocumentos',
            Endpoint__c = 'https://gateway-sf.azurewebsites.net',
            ContentType__c = 'application/json',
            ComplementUrl__c = '/api/v1/opportunities/save-documentdb'
        );

        ExternalAPI__c apiGetFiles = new ExternalAPI__c(
            Name = 'GetFiles',
            GrantType__c = 'test',
            ClientID__c = '123',
            ClientSecret__c = '123',
            Endpoint__c = 'test/',
            ContentType__c = 'application/json',
            ComplementUrl__c = 'test'
        );

        ExternalAPI__c saveDocumentFromAPIDoc = new ExternalAPI__c(
            Name = 'SaveDocument',
            GrantType__c = 'test',
            ClientID__c = '123',
            ClientSecret__c = '123',
            Endpoint__c = 'test/',
            ContentType__c = 'application/json',
            ComplementUrl__c = 'test'
        );

        ExternalAPI__c genesys = new ExternalAPI__c(
            Name = 'Genesys Cloud',
            ClientID__c = 'bdbeda3f-6e8f-4328-95e8-3d3fa2ceb282',
            ClientSecret__c = '02EmhDjYc6CLmemkvYAwec4ldbWQ2DCoWwYtwroEIOA',
            Endpoint__c = 'https://login.sae1.pure.cloud/oauth/token',
            ComplementUrl__c = 'sae1.pure.cloud',
            GrantType__c = 'client_credentials',
            AccessToken__c = '123'
        );
        
        apis.add(sso);
        apis.add(cti);
        apis.add(sipre);
        apis.add(mac);
        apis.add(corporativo);
        apis.add(mktCloudAuth);
        apis.add(mktCloud);
        apis.add(mktCloudRCPM);
        apis.add(mktCloudPrestamista);
        apis.add(mktCloudAgro);
        apis.add(mktCloudB2UWpp);
        apis.add(diretrix);
        apis.add(marketingCloudVIPOpportunity);
        apis.add(marketingCloudVIPAccount);
        apis.add(ssov1);
        apis.add(apidocumentos);
        apis.add(apiwflow);
        apis.add(mktCloudDataExtentionsProduct);
        apis.add(apiSaveDocumentByOpp);
        apis.add(apiGetFiles);
        apis.add(saveDocumentFromAPIDoc);
        apis.add(genesys);

        return apis;
    }

    public static List<ExternalAPI__c> insertExternalAPIs(){
        List<ExternalAPI__c> apis = createExternalAPIs();
        insert apis;
        return apis;
    }
}