/**
 * @description       :
 * @author            :viniciusazevedo@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 02-07-2022
 * @last modified by  :viniciusazevedo@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   02-07-2022  viniciusazevedo@wizsolucoes.com.br   Initial Version
 **/
@isTest
public with sharing class CertifiedTriggerHandlerTest {
    private static Id corporateApoliceRecordType = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName()
    .get('CorporateApolice')
    .getRecordTypeId();    
    
        @isTest
        static void ShoudInsertTriggerHandler(){
            Account acc = AccountDataFactory.insertPersonAccount();
    
            Order orderFairfax = new Order();
            orderFairfax.Name = TestDataFactory.generateRandomStringNumber(10);
            orderFairfax.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
            orderFairfax.PoNumber = '0566920181001077500007189';
            orderFairfax.Company__c = 'Fairfax';
            orderFairfax.Type = 'New';
            orderFairfax.Status = 'CarriedOut';
            orderFairfax.EffectiveDate = Date.today();
            orderFairfax.DateOfFirstInstallment__c = Date.today();
            orderFairfax.PoDate = Date.today();
            orderFairfax.EndDate = Date.today() + 1;
            orderFairfax.NumberOfInstallments__c = '1';
            orderFairfax.RecordTypeId = corporateApoliceRecordType;
            orderFairfax.AccountId = acc.Id;
            insert orderFairfax;

            Test.startTest();
            
                Certified__c objCertifiedTest = new Certified__c();
                objCertifiedTest.RegistrationNumber__c = '123.456-789/';
                objCertifiedTest.ParentOrder__c = orderFairfax.Id;
                insert objCertifiedTest;

                Certified__c objCertified = [SELECT RegistrationNumber__c FROM Certified__c WHERE Id =: objCertifiedTest.Id];

                String expected = '123456789';
                System.debug(objCertified);

                System.assertEquals(expected, objCertified.RegistrationNumber__c, 'Error test insert');

            Test.stopTest();
        }

        @isTest
        public static void ShoudUpdateTriggerHandler(){
            Account acc = AccountDataFactory.insertPersonAccount();
    
            Order orderFairfax = new Order();
            orderFairfax.Name = TestDataFactory.generateRandomStringNumber(10);
            orderFairfax.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
            orderFairfax.PoNumber = '0566920181001077500007189';
            orderFairfax.Company__c = 'Fairfax';
            orderFairfax.Type = 'New';
            orderFairfax.Status = 'CarriedOut';
            orderFairfax.EffectiveDate = Date.today();
            orderFairfax.DateOfFirstInstallment__c = Date.today();
            orderFairfax.PoDate = Date.today();
            orderFairfax.EndDate = Date.today() + 1;
            orderFairfax.NumberOfInstallments__c = '1';
            orderFairfax.RecordTypeId = corporateApoliceRecordType;
            orderFairfax.AccountId = acc.Id;
            insert orderFairfax;

            Test.startTest();

                Certified__c objCertifiedTest = new Certified__c();
                objCertifiedTest.RegistrationNumber__c = '123.456-789/';
                objCertifiedTest.ParentOrder__c = orderFairfax.Id;
                insert objCertifiedTest;
                objCertifiedTest.RegistrationNumber__c = '123.456-789/0001-05';
                update objCertifiedTest;

                Certified__c objCertified = [SELECT RegistrationNumber__c FROM Certified__c WHERE Id =: objCertifiedTest.Id];

                String expected = '123456789000105';


                System.assertEquals(expected, objCertified.RegistrationNumber__c, 'Error test updade');
                
            Test.stopTest();
        }


        
    }