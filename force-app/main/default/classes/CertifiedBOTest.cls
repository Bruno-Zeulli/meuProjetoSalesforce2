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
public class CertifiedBOTest{

    @testSetup
    static void setup (){

        Id corporateApoliceRecordType = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName()
                                                        .get('CorporateApolice')
                                                        .getRecordTypeId();

        Account acc = AccountDataFactory.insertPersonAccount();

        Order objOrder = new Order();
        objOrder.Name = TestDataFactory.generateRandomStringNumber(10);
        objOrder.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        objOrder.PoNumber = '0566920181001077500007189';
        objOrder.Company__c = 'Fairfax';
        objOrder.Type = 'New';
        objOrder.Status = 'CarriedOut';
        objOrder.EffectiveDate = Date.today();
        objOrder.DateOfFirstInstallment__c = Date.today();
        objOrder.PoDate = Date.today();
        objOrder.EndDate = Date.today() + 1;
        objOrder.NumberOfInstallments__c = '1';
        objOrder.RecordTypeId = corporateApoliceRecordType;
        objOrder.AccountId = acc.Id;
        
        insert objOrder;

    }

    @isTest
    static void ShoudReturnErrorNull(){

        List<Order> lstParentOrder = [SELECT Id FROM Order Limit 1];

        Test.startTest();
         try{
            Certified__c objCertifiedTest = new Certified__c();
            objCertifiedTest.RegistrationNumber__c = '';
            objCertifiedTest.ParentOrder__c = lstParentOrder[0].Id;    
            
            insert objCertifiedTest;
            
        } catch (Exception e){
            System.assert(e.getMessage().contains('CertifiedTrigger: execution of BeforeInsert'), 'CertifiedTrigger: execution of BeforeInsert');
        }
        Test.stopTest();
    }

    @isTest
    static void ShoudReturnErrorNotNumber(){

        List<Order> lstParentOrder = [SELECT Id FROM Order Limit 1];
        
        Test.startTest();

        Certified__c objCertifiedTest = new Certified__c();
        objCertifiedTest.RegistrationNumber__c = 'Letra';
        objCertifiedTest.ParentOrder__c = lstParentOrder[0].Id;        

        try{
            insert objCertifiedTest;
        } catch (Exception e){
        System.assert(e.getMessage().contains('Número de Averbação incorreto para este Certificado'), 'Número de Averbação incorreto para este Certificado');
        Test.stopTest();
        }
    }
    @isTest
    static void ShoudReturnErrorLimit20(){

        List<Order> lstParentOrder = [SELECT Id FROM Order Limit 1];

        Test.startTest();
        Certified__c objCertifiedTest = new Certified__c();
        objCertifiedTest.RegistrationNumber__c = '123456789123456789123456';
        objCertifiedTest.ParentOrder__c = lstParentOrder[0].Id;  

         try{
            
            insert objCertifiedTest;

        }catch (Exception e){
            System.assert(e.getMessage().contains('Número de Averbação incorreto para este Certificado'), 'Número de Averbação incorreto para este Certificado');
        }
        Test.stopTest();        
    }

    @isTest
    static void ShoudInsertSuccess(){

        List<Order> lstParentOrder = [SELECT Id FROM Order Limit 1];

        Test.startTest();
        Certified__c objCertifiedTest = new Certified__c();
        objCertifiedTest.RegistrationNumber__c = '123.456-789/';
        objCertifiedTest.ParentOrder__c = lstParentOrder[0].Id;  

        insert objCertifiedTest;

        Certified__c objCertified = [SELECT RegistrationNumber__c FROM Certified__c WHERE Id =: objCertifiedTest.Id];

        String expected = '123456789';
        System.assertEquals(expected, objCertified.RegistrationNumber__c, 'Error test insert');

        Test.stopTest();         
    }
    
    @isTest
    static void ShoudUpdateSuccess(){

        List<Order> lstParentOrder = [SELECT Id FROM Order Limit 1];

        Test.startTest();

        Certified__c objCertifiedTest = new Certified__c();
        objCertifiedTest.RegistrationNumber__c = '123.456-789/';
        objCertifiedTest.ParentOrder__c = lstParentOrder[0].Id;  
        insert objCertifiedTest;
        
        objCertifiedTest.RegistrationNumber__c = '123.456-789/0001-05';
        update objCertifiedTest;

        Certified__c objCertified = [SELECT RegistrationNumber__c FROM Certified__c WHERE Id =: objCertifiedTest.Id];
        
        String expected = '123456789000105';
        System.assertEquals(expected, objCertified.RegistrationNumber__c, 'Error test updade');
    
        Test.stopTest();         
    }
    }