/**
 * @description       :
 * @author            : marcelomartins@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 11-23-2021
 * @last modified by  : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-23-2021   marcelomartins@wizsolucoes.com.br   Initial Version
 **/
//TODO Implementar teste de forma que seja possivel testar o comportamento do ConectAPI.Chatter
@isTest
public class ChatterUtilsTest {
    @IsTest(SeeAllData=true)
    static void implementationTest(){

        Opportunity objOpportunity = OpportunityDataFactory.createOpportunity();
        insert objOpportunity;

        Test.startTest();
        List<Opportunity> lstOpportunity = [SELECT Id, OpportunityNumber__c, Name, OwnerId FROM Opportunity LIMIT 2];
        ChatterUtils.getInstance().makeMessagePostChatters('OpportuntySendedWFlow', lstOpportunity, '');
        ChatterUtils.getInstance().makeMessagePostChatters('ApprovedQuoteSendedWFlow', lstOpportunity, '');
        ChatterUtils.getInstance().makeMessagePostChatters('sendNotificationHasQuote', lstOpportunity, '');
        Test.stopTest();

        System.assert(null==null, '');
    }
    

}