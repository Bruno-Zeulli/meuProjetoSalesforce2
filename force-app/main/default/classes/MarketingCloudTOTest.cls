/**
 * @description       :
 * @author            : andresilva@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 11-25-2021
 * @last modified by  : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                                Modification
 * 1.0   11-25-2021   marcelomartins@wizsolucoes.com.br     Initial Version
 **/
@isTest
public class MarketingCloudTOTest {

    @isTest
    static void instantiateInputMarketingCloud(){
        MarketingCloudTO.InputMarketingCloud inputMarketingCloud = new MarketingCloudTO.InputMarketingCloud();
        inputMarketingCloud.contactKey = '123456';
        inputMarketingCloud.establishContactKey = true;
        inputMarketingCloud.eventDefinitionKey = '123456';
        inputMarketingCloud.data = new MarketingCloudTO.CustomData();
        inputMarketingCloud.data.accountId = '123456';
        inputMarketingCloud.data.callDisposition = '123456';
        inputMarketingCloud.data.campaignName = '123456';
        inputMarketingCloud.data.caseId = '123456';
        inputMarketingCloud.data.clienteCaixa = true;
        inputMarketingCloud.data.contactDetail = '123456';
        inputMarketingCloud.data.contactId = '123456';
        inputMarketingCloud.data.cpfComunicante = '123456';
        inputMarketingCloud.data.cpfSegurado = '123456';
        inputMarketingCloud.data.createdDate = '123456';
        inputMarketingCloud.data.doNotSendMessage = '123456';
        inputMarketingCloud.data.email = '123456';
        inputMarketingCloud.data.produto = '123456';
        inputMarketingCloud.data.mobilePhone = '123456';
        inputMarketingCloud.data.locale = '123456';
        inputMarketingCloud.data.status = '123456';
        inputMarketingCloud.data.saldoResidual = false;
        inputMarketingCloud.data.identificationNumber = '123452321213126';
        inputMarketingCloud.data.name = '123452321213126';
        inputMarketingCloud.data.source = '123452321213126';
         inputMarketingCloud.data.relationshipGroup = '123452321213126';
         inputMarketingCloud.data.taskId = '123452321213126';
         inputMarketingCloud.data.five9AgentName = '123452321213126';
         inputMarketingCloud.data.five9Agent = '123452321213126';


        Integer expected ;
        Integer actual;
        System.assertEquals(expected, actual, 'nothing to expect');
    }

    @isTest
    static void instantiateinputItemsMktcCloud(){
        MarketingCloudTO.InputItemsMktcCloud inputItemsMktcCloud = new MarketingCloudTO.InputItemsMktcCloud();
        List<MarketingCloudTO.Item> lstItem = new List<MarketingCloudTO.Item>();
        MarketingCloudTO.Item item = new MarketingCloudTO.Item();

        item.id = '123456';
        item.isActive = 'true';
        item.name = 'teste';
        item.pricebook2 = 'teste';
        item.pricebook2_Name = 'teste';
        item.product2Id = '123456';
        item.productCode = 'teste';

        lstItem.add(item);

        inputItemsMktcCloud.items = lstItem;

        Integer expected ;
        Integer actual;
        System.assertEquals(expected, actual, 'nothing to expect');
    }


}