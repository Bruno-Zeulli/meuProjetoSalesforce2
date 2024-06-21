/**
 * @description       :
 * @author            : marcelomartins@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 11-24-2021
 * @last modified by  : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-24-2021   marcelomartins@wizsolucoes.com.br   Initial Version
 **/
@isTest
public class DocumentChecklistBOTest {


    @testSetup
    static void setup(){

        Account acc = AccountDataFactory.insertPersonAccount();
        Opportunity opp = OpportunityDataFactory.createOpportunity();
        insert opp;
        Quote quot = QuoteDataFactory.createQuoteCorporate();
        quot.OpportunityId = opp.Id;
        insert quot;
        Case cs = CaseDataFactory.insertCase();
        Order ord = OrderDataFactory.createOrder();
        ord.AccountId = acc.Id;
        insert ord;
        Product2 prod = ProductDataFactory.insertProduct();
        Contract2__c cont = ContractDataFactory.insertContractHab(acc.Id, prod);


        List<DocumentChecklist__c> lstDocCheckList = new List<DocumentChecklist__c>();
       lstDocCheckList.add(
           DocumentChecklistDataFactory.insertDocumentChecklistDynamic(
               acc.Id,
               true,
               'PersonAccount',
               ''
            )
        );
        lstDocCheckList.add(
           DocumentChecklistDataFactory.insertDocumentChecklistDynamic(
               quot.Id,
               true,
               'Corporate',
               'New'
            )
        );
        lstDocCheckList.add(
           DocumentChecklistDataFactory.insertDocumentChecklistDynamic(
               ord.Id,
               true,
               'CorporateApolice',
               'New'
            )
        );
        lstDocCheckList.add(
           DocumentChecklistDataFactory.insertDocumentChecklistDynamic(
               cs.Id,
               true,
               'BPOMundoCaixa',
               'New'
            )
        );
        lstDocCheckList.add(
           DocumentChecklistDataFactory.insertDocumentChecklistDynamic(
               cont.Id,
               true,
               'Insurance',
               ''
            )
        );
        lstDocCheckList.add(
           DocumentChecklistDataFactory.insertDocumentChecklistDynamic(
               opp.Id,
               true,
               'CorporateComercial',
               ''
            )
        );
    }

    @isTest
    static void shouldResultList(){



        Test.startTest();
        List<Account> acc = [SELECT Id FROM Account Limit 1];
        List<Opportunity> opp = [SELECT Id FROM Opportunity Limit 1];
        List<Quote> quot = [SELECT Id FROM Quote Limit 1];
        List<Case> cs = [SELECT Id FROM Case Limit 1];
        List<Order> ord = [SELECT Id FROM Order Limit 1];
        List<Contract2__c> cont = [SELECT Id FROM Contract2__c Limit 1];
        Id prodId = IDGenerator.generate(Product2.getSObjectType());

        List<DocumentChecklist__c> lstDocAcc = DocumentChecklistBO.getInstance().getDocumentsChecklist(acc[0].Id);
        // List<DocumentChecklist__c> lstDocQuote = DocumentChecklistBO.getInstance().getDocumentsChecklist(quot[0].Id);
        List<DocumentChecklist__c> lstDocCase = DocumentChecklistBO.getInstance().getDocumentsChecklist(cs[0].Id);
        // List<DocumentChecklist__c> lstDocOrder = DocumentChecklistBO.getInstance().getDocumentsChecklist(ord[0].Id);
        List<DocumentChecklist__c> lstDocCont = DocumentChecklistBO.getInstance().getDocumentsChecklist(cont[0].Id);
        // List<DocumentChecklist__c> lstDocOpp = DocumentChecklistBO.getInstance().getDocumentsChecklist(opp[0].Id);
        Boolean hasRequired  = DocumentChecklistBO.getInstance().checkPendingMandatoryDocuments(acc[0].Id);
        Boolean notHasRequired = DocumentChecklistBO.getInstance().checkPendingMandatoryDocuments(prodId);
        Test.stopTest();

        Integer expected = 1;
        Integer actual = lstDocAcc.size();
        String expected1 = 'PersonAccount';
        String actual1 = lstDocAcc[0].ObjectRecordType__c;
        Boolean expected2 = true;
        Boolean actual2 = lstDocAcc[0].DocumentRequirement__c;


        System.assertEquals(expected, actual, 'Size not checking with expecteg');
        System.assertEquals(expected1, actual1, 'ObjectRecordType not checking with expecteg');
        System.assertEquals(expected2, actual2, 'DocumentRequirement not checking with expecteg');
        System.assertEquals(hasRequired, true, 'result not checking with expecteg');
        System.assertEquals(notHasRequired, false, 'result not checking with expecteg');

    }

}