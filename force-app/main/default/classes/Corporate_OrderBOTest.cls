/**
* @description       :
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             :
* @last modified on  : 03-02-2021
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
* Modifications Log
* Ver   Date         Author                               Modification
* 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
* 1.1   05-21-2021   ericdaniel@wizsolucoes.com.br      Ajustadas condições para BMG Seguros
**/
@isTest
public class Corporate_OrderBOTest {
    private static Id corporateApoliceRecordType = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName()
        .get('CorporateApolice')
        .getRecordTypeId();
    private static Id corporateEndossoNeutroRecordType = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName()
        .get('CorporateEndossoNeutro')
        .getRecordTypeId();

    @isTest
    public static void processarPoNumber0Test(){

        Test.startTest();
        Account acc = AccountDataFactory.insertPersonAccount();
        Order orderAlfa = new Order();
        orderAlfa.Name = TestDataFactory.generateRandomStringNumber(10);
        orderAlfa.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderAlfa.PoNumber = '2/93/2205';
        orderAlfa.Company__c = 'Alfa Seguros';
        orderAlfa.Type = 'New';
        orderAlfa.Status = 'CarriedOut';
        orderAlfa.EffectiveDate = Date.today();
        orderAlfa.DateOfFirstInstallment__c = Date.today();
        orderAlfa.PoDate = Date.today();
        orderAlfa.EndDate = Date.today() + 1;
        orderAlfa.NumberOfInstallments__c = '1';
        orderAlfa.RecordTypeId = corporateApoliceRecordType;
        orderAlfa.AccountId = acc.Id;

        insert orderAlfa;

         try{
            Order orderAlfa2 = new Order();
            orderAlfa2.Name = TestDataFactory.generateRandomStringNumber(10);
            orderAlfa2.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
            orderAlfa2.PoNumber = '052';
            orderAlfa2.Company__c = 'Alfa Seguros';
            orderAlfa2.Type = 'New';
            orderAlfa2.Status = 'CarriedOut';
            orderAlfa2.EffectiveDate = Date.today();
            orderAlfa2.DateOfFirstInstallment__c = Date.today();
            orderAlfa2.PoDate = Date.today();
            orderAlfa2.EndDate = Date.today() + 1;
            orderAlfa2.NumberOfInstallments__c = '1';
            orderAlfa2.RecordTypeId = corporateApoliceRecordType;
            orderAlfa2.AccountId = acc.Id;

            insert orderAlfa2;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Order orderAIG = new Order();
        orderAIG.Name = TestDataFactory.generateRandomStringNumber(10);
        orderAIG.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderAIG.PoNumber = '087372017010378004672';
        orderAIG.Company__c = 'AIG Seguros';
        orderAIG.Type = 'New';
        orderAIG.Status = 'CarriedOut';
        orderAIG.EffectiveDate = Date.today();
        orderAIG.DateOfFirstInstallment__c = Date.today();
        orderAIG.PoDate = Date.today();
        orderAIG.EndDate = Date.today() + 1;
        orderAIG.NumberOfInstallments__c = '1';
        orderAIG.RecordTypeId = corporateApoliceRecordType;
        orderAIG.AccountId = acc.Id;

        insert orderAIG;

        Order orderAIG2 = new Order();
        orderAIG2.Name = TestDataFactory.generateRandomStringNumber(10);
        orderAIG2.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderAIG2.PoNumber = '10378114672';
        orderAIG2.Company__c = 'AIG Seguros';
        orderAIG2.Type = 'New';
        orderAIG2.Status = 'CarriedOut';
        orderAIG2.EffectiveDate = Date.today();
        orderAIG2.DateOfFirstInstallment__c = Date.today();
        orderAIG2.PoDate = Date.today();
        orderAIG2.EndDate = Date.today() + 1;
        orderAIG2.NumberOfInstallments__c = '1';
        orderAIG2.RecordTypeId = corporateApoliceRecordType;
        orderAIG2.AccountId = acc.Id;

        insert orderAIG2;

         try{
            Order orderAIG3 = new Order();
            orderAIG3.Name = TestDataFactory.generateRandomStringNumber(10);
            orderAIG3.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
            orderAIG3.PoNumber = '10378114672221';
            orderAIG3.Company__c = 'AIG Seguros';
            orderAIG3.Type = 'New';
            orderAIG3.Status = 'CarriedOut';
            orderAIG3.EffectiveDate = Date.today();
            orderAIG3.DateOfFirstInstallment__c = Date.today();
            orderAIG3.PoDate = Date.today();
            orderAIG3.EndDate = Date.today() + 1;
            orderAIG3.NumberOfInstallments__c = '1';
            orderAIG3.RecordTypeId = corporateApoliceRecordType;
            orderAIG3.AccountId = acc.Id;

            insert orderAIG3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Order orderAmerica = new Order();
        orderAmerica.Name = TestDataFactory.generateRandomStringNumber(10);
        orderAmerica.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderAmerica.PoNumber = '058192019010007750000020';
        orderAmerica.Company__c = 'American Life';
        orderAmerica.Type = 'New';
        orderAmerica.Status = 'CarriedOut';
        orderAmerica.EffectiveDate = Date.today();
        orderAmerica.DateOfFirstInstallment__c = Date.today();
        orderAmerica.PoDate = Date.today();
        orderAmerica.EndDate = Date.today() + 1;
        orderAmerica.NumberOfInstallments__c = '1';
        orderAmerica.RecordTypeId = corporateApoliceRecordType;
        orderAmerica.AccountId = acc.Id;

        insert orderAmerica;

        Order orderAmerica2 = new Order();
        orderAmerica2.Name = TestDataFactory.generateRandomStringNumber(10);
        orderAmerica2.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderAmerica2.PoNumber = '100750000202039X';
        orderAmerica2.Company__c = 'American Life';
        orderAmerica2.Type = 'New';
        orderAmerica2.Status = 'CarriedOut';
        orderAmerica2.EffectiveDate = Date.today();
        orderAmerica2.DateOfFirstInstallment__c = Date.today();
        orderAmerica2.PoDate = Date.today();
        orderAmerica2.EndDate = Date.today() + 1;
        orderAmerica2.NumberOfInstallments__c = '1';
        orderAmerica2.RecordTypeId = corporateApoliceRecordType;
        orderAmerica2.AccountId = acc.Id;

        insert orderAmerica2;

        Order orderAmerica3 = new Order();
        orderAmerica3.Name = TestDataFactory.generateRandomStringNumber(10);
        orderAmerica3.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderAmerica3.PoNumber = '1007500002020';
        orderAmerica3.Company__c = 'American Life';
        orderAmerica3.Type = 'New';
        orderAmerica3.Status = 'CarriedOut';
        orderAmerica3.EffectiveDate = Date.today();
        orderAmerica3.DateOfFirstInstallment__c = Date.today();
        orderAmerica3.PoDate = Date.today();
        orderAmerica3.EndDate = Date.today() + 1;
        orderAmerica3.NumberOfInstallments__c = '1';
        orderAmerica3.RecordTypeId = corporateApoliceRecordType;
        orderAmerica3.AccountId = acc.Id;

        insert orderAmerica3;

         try{
            Order orderAmerica4 = new Order();
            orderAmerica4.Name = TestDataFactory.generateRandomStringNumber(10);
            orderAmerica4.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
            orderAmerica4.PoNumber = '020';
            orderAmerica4.Company__c = 'American Life';
            orderAmerica4.Type = 'New';
            orderAmerica4.Status = 'CarriedOut';
            orderAmerica4.EffectiveDate = Date.today();
            orderAmerica4.DateOfFirstInstallment__c = Date.today();
            orderAmerica4.PoDate = Date.today();
            orderAmerica4.EndDate = Date.today() + 1;
            orderAmerica4.NumberOfInstallments__c = '1';
            orderAmerica4.RecordTypeId = corporateApoliceRecordType;
            orderAmerica4.AccountId = acc.Id;

            insert orderAmerica4;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Order orderArgo = new Order();
        orderArgo.Name = TestDataFactory.generateRandomStringNumber(10);
        orderArgo.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderArgo.PoNumber = '02798.2019.01.0310.000034';
        orderArgo.Company__c = 'Argo Seguros';
        orderArgo.Type = 'New';
        orderArgo.Status = 'CarriedOut';
        orderArgo.EffectiveDate = Date.today();
        orderArgo.DateOfFirstInstallment__c = Date.today();
        orderArgo.PoDate = Date.today();
        orderArgo.EndDate = Date.today() + 1;
        orderArgo.NumberOfInstallments__c = '1';
        orderArgo.RecordTypeId = corporateApoliceRecordType;
        orderArgo.AccountId = acc.Id;

        insert orderArgo;

        Order orderArgo2 = new Order();
        orderArgo2.Name = TestDataFactory.generateRandomStringNumber(10);
        orderArgo2.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderArgo2.PoNumber = '027982019010310002034';
        orderArgo2.Company__c = 'Argo Seguros';
        orderArgo2.Type = 'New';
        orderArgo2.Status = 'CarriedOut';
        orderArgo2.EffectiveDate = Date.today();
        orderArgo2.DateOfFirstInstallment__c = Date.today();
        orderArgo2.PoDate = Date.today();
        orderArgo2.EndDate = Date.today() + 1;
        orderArgo2.NumberOfInstallments__c = '1';
        orderArgo2.RecordTypeId = corporateApoliceRecordType;
        orderArgo2.AccountId = acc.Id;

        insert orderArgo2;

         try{
            Order orderArgo3 = new Order();
            orderArgo3.Name = TestDataFactory.generateRandomStringNumber(10);
            orderArgo3.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
            orderArgo3.PoNumber = '0279820002034';
            orderArgo3.Company__c = 'Argo Seguros';
            orderArgo3.Type = 'New';
            orderArgo3.Status = 'CarriedOut';
            orderArgo3.EffectiveDate = Date.today();
            orderArgo3.DateOfFirstInstallment__c = Date.today();
            orderArgo3.PoDate = Date.today();
            orderArgo3.EndDate = Date.today() + 1;
            orderArgo3.NumberOfInstallments__c = '1';
            orderArgo3.RecordTypeId = corporateApoliceRecordType;
            orderArgo3.AccountId = acc.Id;

            insert orderArgo3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Order orderAustral = new Order();
        orderAustral.Name = TestDataFactory.generateRandomStringNumber(10);
        orderAustral.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderAustral.PoNumber = '027982019010310002034234';
        orderAustral.Company__c = 'Austral Seguros';
        orderAustral.Type = 'New';
        orderAustral.Status = 'CarriedOut';
        orderAustral.EffectiveDate = Date.today();
        orderAustral.DateOfFirstInstallment__c = Date.today();
        orderAustral.PoDate = Date.today();
        orderAustral.EndDate = Date.today() + 1;
        orderAustral.NumberOfInstallments__c = '1';
        orderAustral.RecordTypeId = corporateApoliceRecordType;
        orderAustral.AccountId = acc.Id;

        insert orderAustral;

        Order orderAustral2 = new Order();
        orderAustral2.Name = TestDataFactory.generateRandomStringNumber(10);
        orderAustral2.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderAustral2.PoNumber = '002034234222';
        orderAustral2.Company__c = 'Austral Seguros';
        orderAustral2.Type = 'New';
        orderAustral2.Status = 'CarriedOut';
        orderAustral2.EffectiveDate = Date.today();
        orderAustral2.DateOfFirstInstallment__c = Date.today();
        orderAustral2.PoDate = Date.today();
        orderAustral2.EndDate = Date.today() + 1;
        orderAustral2.NumberOfInstallments__c = '1';
        orderAustral2.RecordTypeId = corporateApoliceRecordType;
        orderAustral2.AccountId = acc.Id;

        insert orderAustral2;

         try{
            Order orderAustral3 = new Order();
            orderAustral3.Name = TestDataFactory.generateRandomStringNumber(10);
            orderAustral3.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
            orderAustral3.PoNumber = '00203';
            orderAustral3.Company__c = 'Austral Seguros';
            orderAustral3.Type = 'New';
            orderAustral3.Status = 'CarriedOut';
            orderAustral3.EffectiveDate = Date.today();
            orderAustral3.DateOfFirstInstallment__c = Date.today();
            orderAustral3.PoDate = Date.today();
            orderAustral3.EndDate = Date.today() + 1;
            orderAustral3.NumberOfInstallments__c = '1';
            orderAustral3.RecordTypeId = corporateApoliceRecordType;
            orderAustral3.AccountId = acc.Id;

            insert orderAustral3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }
        Test.stopTest();
    }
    @isTest
    public static void processarPoNumber1Test(){
        Test.startTest();
                Account acc = AccountDataFactory.insertPersonAccount();

        Order orderAazul = new Order();
        orderAazul.Name = TestDataFactory.generateRandomStringNumber(10);
        orderAazul.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderAazul.PoNumber = '16.19.0531.037406.000';
        orderAazul.Company__c = 'Azul Seguros';
        orderAazul.Type = 'New';
        orderAazul.Status = 'CarriedOut';
        orderAazul.EffectiveDate = Date.today();
        orderAazul.DateOfFirstInstallment__c = Date.today();
        orderAazul.PoDate = Date.today();
        orderAazul.EndDate = Date.today() + 1;
        orderAazul.NumberOfInstallments__c = '1';
        orderAazul.RecordTypeId = corporateApoliceRecordType;
        orderAazul.AccountId = acc.Id;

        insert orderAazul;

        Order orderAazul2 = new Order();
        orderAazul2.Name = TestDataFactory.generateRandomStringNumber(10);
        orderAazul2.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderAazul2.PoNumber = '17190531037406000';
        orderAazul2.Company__c = 'Azul Seguros';
        orderAazul2.Type = 'New';
        orderAazul2.Status = 'CarriedOut';
        orderAazul2.EffectiveDate = Date.today();
        orderAazul2.DateOfFirstInstallment__c = Date.today();
        orderAazul2.PoDate = Date.today();
        orderAazul2.EndDate = Date.today() + 1;
        orderAazul2.NumberOfInstallments__c = '1';
        orderAazul2.RecordTypeId = corporateApoliceRecordType;
        orderAazul2.AccountId = acc.Id;

        insert orderAazul2;

         try{
            Order orderAazul3 = new Order();
            orderAazul3.Name = TestDataFactory.generateRandomStringNumber(10);
            orderAazul3.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
            orderAazul3.PoNumber = '1037406000';
            orderAazul3.Company__c = 'Azul Seguros';
            orderAazul3.Type = 'New';
            orderAazul3.Status = 'CarriedOut';
            orderAazul3.EffectiveDate = Date.today();
            orderAazul3.DateOfFirstInstallment__c = Date.today();
            orderAazul3.PoDate = Date.today();
            orderAazul3.EndDate = Date.today() + 1;
            orderAazul3.NumberOfInstallments__c = '1';
            orderAazul3.RecordTypeId = corporateApoliceRecordType;
            orderAazul3.AccountId = acc.Id;

            insert orderAazul3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Order orderAxa = new Order();
        orderAxa.Name = TestDataFactory.generateRandomStringNumber(10);
        orderAxa.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderAxa.PoNumber = '02852.2018.0062.0118.0005297';
        orderAxa.Company__c = 'Axa Seguros';
        orderAxa.Type = 'New';
        orderAxa.Status = 'CarriedOut';
        orderAxa.EffectiveDate = Date.today();
        orderAxa.DateOfFirstInstallment__c = Date.today();
        orderAxa.PoDate = Date.today();
        orderAxa.EndDate = Date.today() + 1;
        orderAxa.NumberOfInstallments__c = '1';
        orderAxa.RecordTypeId = corporateApoliceRecordType;
        orderAxa.AccountId = acc.Id;

        insert orderAxa;

        Order orderAxa2 = new Order();
        orderAxa2.Name = TestDataFactory.generateRandomStringNumber(10);
        orderAxa2.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderAxa2.PoNumber = '5298';
        orderAxa2.Company__c = 'Axa Seguros';
        orderAxa2.Type = 'New';
        orderAxa2.Status = 'CarriedOut';
        orderAxa2.EffectiveDate = Date.today();
        orderAxa2.DateOfFirstInstallment__c = Date.today();
        orderAxa2.PoDate = Date.today();
        orderAxa2.EndDate = Date.today() + 1;
        orderAxa2.NumberOfInstallments__c = '1';
        orderAxa2.RecordTypeId = corporateApoliceRecordType;
        orderAxa2.AccountId = acc.Id;

        insert orderAxa2;

         try{
            Order orderAxa3 = new Order();
            orderAxa3.Name = TestDataFactory.generateRandomStringNumber(10);
            orderAxa3.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
            orderAxa3.PoNumber = '8';
            orderAxa3.Company__c = 'Axa Seguros';
            orderAxa3.Type = 'New';
            orderAxa3.Status = 'CarriedOut';
            orderAxa3.EffectiveDate = Date.today();
            orderAxa3.DateOfFirstInstallment__c = Date.today();
            orderAxa3.PoDate = Date.today();
            orderAxa3.EndDate = Date.today() + 1;
            orderAxa3.NumberOfInstallments__c = '1';
            orderAxa3.RecordTypeId = corporateApoliceRecordType;
            orderAxa3.AccountId = acc.Id;

            insert orderAxa3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Order orderBerkley = new Order();
        orderBerkley.Name = TestDataFactory.generateRandomStringNumber(10);
        orderBerkley.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderBerkley.PoNumber = '014142018000307670021118';
        orderBerkley.Company__c = 'Berkley Seguros';
        orderBerkley.Type = 'New';
        orderBerkley.Status = 'CarriedOut';
        orderBerkley.EffectiveDate = Date.today();
        orderBerkley.DateOfFirstInstallment__c = Date.today();
        orderBerkley.PoDate = Date.today();
        orderBerkley.EndDate = Date.today() + 1;
        orderBerkley.NumberOfInstallments__c = '1';
        orderBerkley.RecordTypeId = corporateApoliceRecordType;
        orderBerkley.AccountId = acc.Id;

        insert orderBerkley;

        Order orderBerkley2 = new Order();
        orderBerkley2.Name = TestDataFactory.generateRandomStringNumber(10);
        orderBerkley2.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderBerkley2.PoNumber = '1007500073209';
        orderBerkley2.Company__c = 'Berkley Seguros';
        orderBerkley2.Type = 'New';
        orderBerkley2.Status = 'CarriedOut';
        orderBerkley2.EffectiveDate = Date.today();
        orderBerkley2.DateOfFirstInstallment__c = Date.today();
        orderBerkley2.PoDate = Date.today();
        orderBerkley2.EndDate = Date.today() + 1;
        orderBerkley2.NumberOfInstallments__c = '1';
        orderBerkley2.RecordTypeId = corporateApoliceRecordType;
        orderBerkley2.AccountId = acc.Id;

        insert orderBerkley2;

         try{
            Order orderBerkley3 = new Order();
            orderBerkley3.Name = TestDataFactory.generateRandomStringNumber(10);
            orderBerkley3.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
            orderBerkley3.PoNumber = '109';
            orderBerkley3.Company__c = 'Berkley Seguros';
            orderBerkley3.Type = 'New';
            orderBerkley3.Status = 'CarriedOut';
            orderBerkley3.EffectiveDate = Date.today();
            orderBerkley3.DateOfFirstInstallment__c = Date.today();
            orderBerkley3.PoDate = Date.today();
            orderBerkley3.EndDate = Date.today() + 1;
            orderBerkley3.NumberOfInstallments__c = '1';
            orderBerkley3.RecordTypeId = corporateApoliceRecordType;
            orderBerkley3.AccountId = acc.Id;

            insert orderBerkley3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Order orderBMG = new Order();
        orderBMG.Name = TestDataFactory.generateRandomStringNumber(10);
        orderBMG.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderBMG.PoNumber = '017412017000107750000685';
        orderBMG.Company__c = 'BMG Seguros';
        orderBMG.Type = 'New';
        orderBMG.Status = 'CarriedOut';
        orderBMG.EffectiveDate = Date.today();
        orderBMG.DateOfFirstInstallment__c = Date.today();
        orderBMG.PoDate = Date.today();
        orderBMG.EndDate = Date.today() + 1;
        orderBMG.NumberOfInstallments__c = '1';
        orderBMG.RecordTypeId = corporateApoliceRecordType;
        orderBMG.AccountId = acc.Id;

        insert orderBMG;

        Order orderBMG2 = new Order();
        orderBMG2.Name = TestDataFactory.generateRandomStringNumber(10);
        orderBMG2.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderBMG2.PoNumber = '1234567890123';
        orderBMG2.Company__c = 'BMG Seguros';
        orderBMG2.Type = 'New';
        orderBMG2.Status = 'CarriedOut';
        orderBMG2.EffectiveDate = Date.today();
        orderBMG2.DateOfFirstInstallment__c = Date.today();
        orderBMG2.PoDate = Date.today();
        orderBMG2.EndDate = Date.today() + 1;
        orderBMG2.NumberOfInstallments__c = '1';
        orderBMG2.RecordTypeId = corporateApoliceRecordType;
        orderBMG2.AccountId = acc.Id;

        insert orderBMG2;
         try{
            Order orderBMG3 = new Order();
            orderBMG3.Name = TestDataFactory.generateRandomStringNumber(10);
            orderBMG3.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
            orderBMG3.PoNumber = '1';
            orderBMG3.Company__c = 'BMG Seguros';
            orderBMG3.Type = 'New';
            orderBMG3.Status = 'CarriedOut';
            orderBMG3.EffectiveDate = Date.today();
            orderBMG3.DateOfFirstInstallment__c = Date.today();
            orderBMG3.PoDate = Date.today();
            orderBMG3.EndDate = Date.today() + 1;
            orderBMG3.NumberOfInstallments__c = '1';
            orderBMG3.RecordTypeId = corporateApoliceRecordType;
            orderBMG3.AccountId = acc.Id;

            insert orderBMG3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Order orderBMG4 = new Order();
        orderBMG4.Name = TestDataFactory.generateRandomStringNumber(10);
        orderBMG4.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderBMG4.PoNumber = '1007750000686';
        orderBMG4.Company__c = 'BMG Seguros';
        orderBMG4.Type = 'New';
        orderBMG4.Status = 'CarriedOut';
        orderBMG4.EffectiveDate = Date.today();
        orderBMG4.DateOfFirstInstallment__c = Date.today();
        orderBMG4.PoDate = Date.today();
        orderBMG4.EndDate = Date.today() + 1;
        orderBMG4.NumberOfInstallments__c = '1';
        orderBMG4.RecordTypeId = corporateApoliceRecordType;
        orderBMG4.AccountId = acc.Id;

        insert orderBMG4;

        Order orderBMG5 = new Order();
        orderBMG5.Name = TestDataFactory.generateRandomStringNumber(10);
        orderBMG5.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderBMG5.PoNumber = '1234567890121007750400686';
        orderBMG5.Company__c = 'BMG Seguros';
        orderBMG5.Type = 'New';
        orderBMG5.Status = 'CarriedOut';
        orderBMG5.EffectiveDate = Date.today();
        orderBMG5.DateOfFirstInstallment__c = Date.today();
        orderBMG5.PoDate = Date.today();
        orderBMG5.EndDate = Date.today() + 1;
        orderBMG5.NumberOfInstallments__c = '1';
        orderBMG5.RecordTypeId = corporateApoliceRecordType;
        orderBMG5.AccountId = acc.Id;

        insert orderBMG5;

        // Order orderBradesco = new Order();
        // orderBradesco.Name = TestDataFactory.generateRandomStringNumber(10);
        // orderBradesco.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        // orderBradesco.PoNumber = '0981.990.0244.015717';
        // orderBradesco.Company__c = 'Bradesco Seguros';
        // orderBradesco.Type = 'New';
        // orderBradesco.Status = 'CarriedOut';
        // orderBradesco.EffectiveDate = Date.today();
        // orderBradesco.DateOfFirstInstallment__c = Date.today();
        // orderBradesco.PoDate = Date.today();
        // orderBradesco.EndDate = Date.today() + 1;
        // orderBradesco.NumberOfInstallments__c = '1';
        // orderBradesco.RecordTypeId = corporateApoliceRecordType;
        // orderBradesco.AccountId = acc.Id;

        // insert orderBradesco;
        Test.stopTest();
    }
//   @isTest
//     public static void processarPoNumber2Test(){
//         Test.startTest();
//         Account acc = AccountDataFactory.insertPersonAccount();

//         // Order orderBradesco2 = new Order();
//         // orderBradesco2.Name = TestDataFactory.generateRandomStringNumber(10);
//         // orderBradesco2.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
//         // orderBradesco2.PoNumber = '09819900244015718';
//         // orderBradesco2.Company__c = 'Bradesco Seguros';
//         // orderBradesco2.Type = 'New';
//         // orderBradesco2.Status = 'CarriedOut';
//         // orderBradesco2.EffectiveDate = Date.today();
//         // orderBradesco2.DateOfFirstInstallment__c = Date.today();
//         // orderBradesco2.PoDate = Date.today();
//         // orderBradesco2.EndDate = Date.today() + 1;
//         // orderBradesco2.NumberOfInstallments__c = '1';
//         // orderBradesco2.RecordTypeId = corporateApoliceRecordType;
//         // orderBradesco2.AccountId = acc.Id;

//         // insert orderBradesco2;

//         Order orderBradesco3 = new Order();
//         orderBradesco3.Name = TestDataFactory.generateRandomStringNumber(10);
//         orderBradesco3.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
//         orderBradesco3.PoNumber = '015';
//         orderBradesco3.Company__c = 'Bradesco Seguros';
//         orderBradesco3.Type = 'New';
//         orderBradesco3.Status = 'CarriedOut';
//         orderBradesco3.EffectiveDate = Date.today();
//         orderBradesco3.DateOfFirstInstallment__c = Date.today();
//         orderBradesco3.PoDate = Date.today();
//         orderBradesco3.EndDate = Date.today() + 1;
//         orderBradesco3.NumberOfInstallments__c = '1';
//         orderBradesco3.RecordTypeId = corporateApoliceRecordType;
//         orderBradesco3.AccountId = acc.Id;

//         insert orderBradesco3;

//          try{
//             Order orderBradesco4 = new Order();
//             orderBradesco4.Name = TestDataFactory.generateRandomStringNumber(10);
//             orderBradesco4.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
//             orderBradesco4.PoNumber = '01';
//             orderBradesco4.Company__c = 'Bradesco Seguros';
//             orderBradesco4.Type = 'New';
//             orderBradesco4.Status = 'CarriedOut';
//             orderBradesco4.EffectiveDate = Date.today();
//             orderBradesco4.DateOfFirstInstallment__c = Date.today();
//             orderBradesco4.PoDate = Date.today();
//             orderBradesco4.EndDate = Date.today() + 1;
//             orderBradesco4.NumberOfInstallments__c = '1';
//             orderBradesco4.RecordTypeId = corporateApoliceRecordType;
//             orderBradesco4.AccountId = acc.Id;

//             insert orderBradesco4;
//         } catch (Exception e){
//             System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
//         }

//         Order orderCapemisa = new Order();
//         orderCapemisa.Name = TestDataFactory.generateRandomStringNumber(10);
//         orderCapemisa.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
//         orderCapemisa.PoNumber = '017412016000107750000053';
//         orderCapemisa.Company__c = 'Capemisa';
//         orderCapemisa.Type = 'New';
//         orderCapemisa.Status = 'CarriedOut';
//         orderCapemisa.EffectiveDate = Date.today();
//         orderCapemisa.DateOfFirstInstallment__c = Date.today();
//         orderCapemisa.PoDate = Date.today();
//         orderCapemisa.EndDate = Date.today() + 1;
//         orderCapemisa.NumberOfInstallments__c = '1';
//         orderCapemisa.RecordTypeId = corporateApoliceRecordType;
//         orderCapemisa.AccountId = acc.Id;

//         insert orderCapemisa;

//         Order orderCapemisa2 = new Order();
//         orderCapemisa2.Name = TestDataFactory.generateRandomStringNumber(10);
//         orderCapemisa2.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
//         orderCapemisa2.PoNumber = '107750000054';
//         orderCapemisa2.Company__c = 'Capemisa';
//         orderCapemisa2.Type = 'New';
//         orderCapemisa2.Status = 'CarriedOut';
//         orderCapemisa2.EffectiveDate = Date.today();
//         orderCapemisa2.DateOfFirstInstallment__c = Date.today();
//         orderCapemisa2.PoDate = Date.today();
//         orderCapemisa2.EndDate = Date.today() + 1;
//         orderCapemisa2.NumberOfInstallments__c = '1';
//         orderCapemisa2.RecordTypeId = corporateApoliceRecordType;
//         orderCapemisa2.AccountId = acc.Id;

//         insert orderCapemisa2;

//          try{
//             Order orderCapemisa3 = new Order();
//             orderCapemisa3.Name = TestDataFactory.generateRandomStringNumber(10);
//             orderCapemisa3.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
//             orderCapemisa3.PoNumber = '4';
//             orderCapemisa3.Company__c = 'Capemisa';
//             orderCapemisa3.Type = 'New';
//             orderCapemisa3.Status = 'CarriedOut';
//             orderCapemisa3.EffectiveDate = Date.today();
//             orderCapemisa3.DateOfFirstInstallment__c = Date.today();
//             orderCapemisa3.PoDate = Date.today();
//             orderCapemisa3.EndDate = Date.today() + 1;
//             orderCapemisa3.NumberOfInstallments__c = '1';
//             orderCapemisa3.RecordTypeId = corporateApoliceRecordType;
//             orderCapemisa3.AccountId = acc.Id;

//             insert orderCapemisa3;
//         } catch (Exception e){
//             System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
//         }

//         Order orderCescebrasil = new Order();
//         orderCescebrasil.Name = TestDataFactory.generateRandomStringNumber(10);
//         orderCescebrasil.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
//         orderCescebrasil.PoNumber = '069982019000207750035629';
//         orderCescebrasil.Company__c = 'Cescebrasil';
//         orderCescebrasil.Type = 'New';
//         orderCescebrasil.Status = 'CarriedOut';
//         orderCescebrasil.EffectiveDate = Date.today();
//         orderCescebrasil.DateOfFirstInstallment__c = Date.today();
//         orderCescebrasil.PoDate = Date.today();
//         orderCescebrasil.EndDate = Date.today() + 1;
//         orderCescebrasil.NumberOfInstallments__c = '1';
//         orderCescebrasil.RecordTypeId = corporateApoliceRecordType;
//         orderCescebrasil.AccountId = acc.Id;

//         insert orderCescebrasil;

//         Order orderCescebrasil2 = new Order();
//         orderCescebrasil2.Name = TestDataFactory.generateRandomStringNumber(10);
//         orderCescebrasil2.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
//         orderCescebrasil2.PoNumber = '1004900000348';
//         orderCescebrasil2.Company__c = 'Cescebrasil';
//         orderCescebrasil2.Type = 'New';
//         orderCescebrasil2.Status = 'CarriedOut';
//         orderCescebrasil2.EffectiveDate = Date.today();
//         orderCescebrasil2.DateOfFirstInstallment__c = Date.today();
//         orderCescebrasil2.PoDate = Date.today();
//         orderCescebrasil2.EndDate = Date.today() + 1;
//         orderCescebrasil2.NumberOfInstallments__c = '1';
//         orderCescebrasil2.RecordTypeId = corporateApoliceRecordType;
//         orderCescebrasil2.AccountId = acc.Id;

//         insert orderCescebrasil2;

//          try{
//             Order orderCescebrasil3 = new Order();
//             orderCescebrasil3.Name = TestDataFactory.generateRandomStringNumber(10);
//             orderCescebrasil3.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
//             orderCescebrasil3.PoNumber = '4';
//             orderCescebrasil3.Company__c = 'Cescebrasil';
//             orderCescebrasil3.Type = 'New';
//             orderCescebrasil3.Status = 'CarriedOut';
//             orderCescebrasil3.EffectiveDate = Date.today();
//             orderCescebrasil3.DateOfFirstInstallment__c = Date.today();
//             orderCescebrasil3.PoDate = Date.today();
//             orderCescebrasil3.EndDate = Date.today() + 1;
//             orderCescebrasil3.NumberOfInstallments__c = '1';
//             orderCescebrasil3.RecordTypeId = corporateApoliceRecordType;
//             orderCescebrasil3.AccountId = acc.Id;

//             insert orderCescebrasil3;
//         } catch (Exception e){
//             System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
//         }

//         Order orderChubb = new Order();
//         orderChubb.Name = TestDataFactory.generateRandomStringNumber(10);
//         orderChubb.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
//         orderChubb.PoNumber = '01.18.0000153.65';
//         orderChubb.Company__c = 'Chubb Seguros';
//         orderChubb.Type = 'New';
//         orderChubb.Status = 'CarriedOut';
//         orderChubb.EffectiveDate = Date.today();
//         orderChubb.DateOfFirstInstallment__c = Date.today();
//         orderChubb.PoDate = Date.today();
//         orderChubb.EndDate = Date.today() + 1;
//         orderChubb.NumberOfInstallments__c = '1';
//         orderChubb.RecordTypeId = corporateApoliceRecordType;
//         orderChubb.AccountId = acc.Id;

//         insert orderChubb;

//         Order orderChubb2 = new Order();
//         orderChubb2.Name = TestDataFactory.generateRandomStringNumber(10);
//         orderChubb2.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
//         orderChubb2.PoNumber = '1180061465';
//         orderChubb2.Company__c = 'Chubb Seguros';
//         orderChubb2.Type = 'New';
//         orderChubb2.Status = 'CarriedOut';
//         orderChubb2.EffectiveDate = Date.today();
//         orderChubb2.DateOfFirstInstallment__c = Date.today();
//         orderChubb2.PoDate = Date.today();
//         orderChubb2.EndDate = Date.today() + 1;
//         orderChubb2.NumberOfInstallments__c = '1';
//         orderChubb2.RecordTypeId = corporateApoliceRecordType;
//         orderChubb2.AccountId = acc.Id;

//         insert orderChubb2;

//          try{
//             Order orderChubb3 = new Order();
//             orderChubb3.Name = TestDataFactory.generateRandomStringNumber(10);
//             orderChubb3.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
//             orderChubb3.PoNumber = '4';
//             orderChubb3.Company__c = 'Chubb Seguros';
//             orderChubb3.Type = 'New';
//             orderChubb3.Status = 'CarriedOut';
//             orderChubb3.EffectiveDate = Date.today();
//             orderChubb3.DateOfFirstInstallment__c = Date.today();
//             orderChubb3.PoDate = Date.today();
//             orderChubb3.EndDate = Date.today() + 1;
//             orderChubb3.NumberOfInstallments__c = '1';
//             orderChubb3.RecordTypeId = corporateApoliceRecordType;
//             orderChubb3.AccountId = acc.Id;

//             insert orderChubb3;
//         } catch (Exception e){
//             System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
//         }

//         Order orderExcelsior = new Order();
//         orderExcelsior.Name = TestDataFactory.generateRandomStringNumber(10);
//         orderExcelsior.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
//         orderExcelsior.PoNumber = '02710005520';
//         orderExcelsior.Company__c = 'Excelsior Seguros';
//         orderExcelsior.Type = 'New';
//         orderExcelsior.Status = 'CarriedOut';
//         orderExcelsior.EffectiveDate = Date.today();
//         orderExcelsior.DateOfFirstInstallment__c = Date.today();
//         orderExcelsior.PoDate = Date.today();
//         orderExcelsior.EndDate = Date.today() + 1;
//         orderExcelsior.NumberOfInstallments__c = '1';
//         orderExcelsior.RecordTypeId = corporateApoliceRecordType;
//         orderExcelsior.AccountId = acc.Id;

//         insert orderExcelsior;

//         Order orderExcelsior2 = new Order();
//         orderExcelsior2.Name = TestDataFactory.generateRandomStringNumber(10);
//         orderExcelsior2.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
//         orderExcelsior2.PoNumber = '2720005520';
//         orderExcelsior2.Company__c = 'Excelsior Seguros';
//         orderExcelsior2.Type = 'New';
//         orderExcelsior2.Status = 'CarriedOut';
//         orderExcelsior2.EffectiveDate = Date.today();
//         orderExcelsior2.DateOfFirstInstallment__c = Date.today();
//         orderExcelsior2.PoDate = Date.today();
//         orderExcelsior2.EndDate = Date.today() + 1;
//         orderExcelsior2.NumberOfInstallments__c = '1';
//         orderExcelsior2.RecordTypeId = corporateApoliceRecordType;
//         orderExcelsior2.AccountId = acc.Id;

//         insert orderExcelsior2;

//          try{
//             Order orderExcelsior3 = new Order();
//             orderExcelsior3.Name = TestDataFactory.generateRandomStringNumber(10);
//             orderExcelsior3.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
//             orderExcelsior3.PoNumber = '4';
//             orderExcelsior3.Company__c = 'Excelsior Seguros';
//             orderExcelsior3.Type = 'New';
//             orderExcelsior3.Status = 'CarriedOut';
//             orderExcelsior3.EffectiveDate = Date.today();
//             orderExcelsior3.DateOfFirstInstallment__c = Date.today();
//             orderExcelsior3.PoDate = Date.today();
//             orderExcelsior3.EndDate = Date.today() + 1;
//             orderExcelsior3.NumberOfInstallments__c = '1';
//             orderExcelsior3.RecordTypeId = corporateApoliceRecordType;
//             orderExcelsior3.AccountId = acc.Id;

//             insert orderExcelsior3;
//         } catch (Exception e){
//             System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
//         }
//         Test.stopTest();
//     }
    @isTest
    public static void processarPoNumber3Test(){
        Test.startTest();
        Account acc = AccountDataFactory.insertPersonAccount();

        Order orderEzze = new Order();
        orderEzze.Name = TestDataFactory.generateRandomStringNumber(10);
        orderEzze.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderEzze.PoNumber = '036462019000107757000068';
        orderEzze.Company__c = 'Ezze Seguros';
        orderEzze.Type = 'New';
        orderEzze.Status = 'CarriedOut';
        orderEzze.EffectiveDate = Date.today();
        orderEzze.DateOfFirstInstallment__c = Date.today();
        orderEzze.PoDate = Date.today();
        orderEzze.EndDate = Date.today() + 1;
        orderEzze.NumberOfInstallments__c = '1';
        orderEzze.RecordTypeId = corporateApoliceRecordType;
        orderEzze.AccountId = acc.Id;

        insert orderEzze;

        Order orderEzze2 = new Order();
        orderEzze2.Name = TestDataFactory.generateRandomStringNumber(10);
        orderEzze2.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderEzze2.PoNumber = '1007507000013';
        orderEzze2.Company__c = 'Ezze Seguros';
        orderEzze2.Type = 'New';
        orderEzze2.Status = 'CarriedOut';
        orderEzze2.EffectiveDate = Date.today();
        orderEzze2.DateOfFirstInstallment__c = Date.today();
        orderEzze2.PoDate = Date.today();
        orderEzze2.EndDate = Date.today() + 1;
        orderEzze2.NumberOfInstallments__c = '1';
        orderEzze2.RecordTypeId = corporateApoliceRecordType;
        orderEzze2.AccountId = acc.Id;

        insert orderEzze2;

         try{
            Order orderEzze3 = new Order();
            orderEzze3.Name = TestDataFactory.generateRandomStringNumber(10);
            orderEzze3.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
            orderEzze3.PoNumber = '4';
            orderEzze3.Company__c = 'Ezze Seguros';
            orderEzze3.Type = 'New';
            orderEzze3.Status = 'CarriedOut';
            orderEzze3.EffectiveDate = Date.today();
            orderEzze3.DateOfFirstInstallment__c = Date.today();
            orderEzze3.PoDate = Date.today();
            orderEzze3.EndDate = Date.today() + 1;
            orderEzze3.NumberOfInstallments__c = '1';
            orderEzze3.RecordTypeId = corporateApoliceRecordType;
            orderEzze3.AccountId = acc.Id;

            insert orderEzze3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Order orderFator = new Order();
        orderFator.Name = TestDataFactory.generateRandomStringNumber(10);
        orderFator.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderFator.PoNumber = '046692019100107750012194';
        orderFator.Company__c = 'Fator';
        orderFator.Type = 'New';
        orderFator.Status = 'CarriedOut';
        orderFator.EffectiveDate = Date.today();
        orderFator.DateOfFirstInstallment__c = Date.today();
        orderFator.PoDate = Date.today();
        orderFator.EndDate = Date.today() + 1;
        orderFator.NumberOfInstallments__c = '1';
        orderFator.RecordTypeId = corporateApoliceRecordType;
        orderFator.AccountId = acc.Id;

        insert orderFator;

        Order orderFator2 = new Order();
        orderFator2.Name = TestDataFactory.generateRandomStringNumber(10);
        orderFator2.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderFator2.PoNumber = '1007800000439';
        orderFator2.Company__c = 'Fator';
        orderFator2.Type = 'New';
        orderFator2.Status = 'CarriedOut';
        orderFator2.EffectiveDate = Date.today();
        orderFator2.DateOfFirstInstallment__c = Date.today();
        orderFator2.PoDate = Date.today();
        orderFator2.EndDate = Date.today() + 1;
        orderFator2.NumberOfInstallments__c = '1';
        orderFator2.RecordTypeId = corporateApoliceRecordType;
        orderFator2.AccountId = acc.Id;

        insert orderFator2;

         try{
            Order orderFator3 = new Order();
            orderFator3.Name = TestDataFactory.generateRandomStringNumber(10);
            orderFator3.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
            orderFator3.PoNumber = '4';
            orderFator3.Company__c = 'Fator';
            orderFator3.Type = 'New';
            orderFator3.Status = 'CarriedOut';
            orderFator3.EffectiveDate = Date.today();
            orderFator3.DateOfFirstInstallment__c = Date.today();
            orderFator3.PoDate = Date.today();
            orderFator3.EndDate = Date.today() + 1;
            orderFator3.NumberOfInstallments__c = '1';
            orderFator3.RecordTypeId = corporateApoliceRecordType;
            orderFator3.AccountId = acc.Id;

            insert orderFator3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Order orderGenerali = new Order();
        orderGenerali.Name = TestDataFactory.generateRandomStringNumber(10);
        orderGenerali.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderGenerali.PoNumber = '53311132807';
        orderGenerali.Company__c = 'Generali Seguros';
        orderGenerali.Type = 'New';
        orderGenerali.Status = 'CarriedOut';
        orderGenerali.EffectiveDate = Date.today();
        orderGenerali.DateOfFirstInstallment__c = Date.today();
        orderGenerali.PoDate = Date.today();
        orderGenerali.EndDate = Date.today() + 1;
        orderGenerali.NumberOfInstallments__c = '1';
        orderGenerali.RecordTypeId = corporateApoliceRecordType;
        orderGenerali.AccountId = acc.Id;

        insert orderGenerali;

        Order orderGenerali2 = new Order();
        orderGenerali2.Name = TestDataFactory.generateRandomStringNumber(10);
        orderGenerali2.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderGenerali2.PoNumber = '53311075555';
        orderGenerali2.Company__c = 'Generali Seguros';
        orderGenerali2.Type = 'New';
        orderGenerali2.Status = 'CarriedOut';
        orderGenerali2.EffectiveDate = Date.today();
        orderGenerali2.DateOfFirstInstallment__c = Date.today();
        orderGenerali2.PoDate = Date.today();
        orderGenerali2.EndDate = Date.today() + 1;
        orderGenerali2.NumberOfInstallments__c = '1';
        orderGenerali2.RecordTypeId = corporateApoliceRecordType;
        orderGenerali2.AccountId = acc.Id;

        insert orderGenerali2;

         try{
            Order orderGenerali3 = new Order();
            orderGenerali3.Name = TestDataFactory.generateRandomStringNumber(10);
            orderGenerali3.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
            orderGenerali3.PoNumber = '4';
            orderGenerali3.Company__c = 'Generali Seguros';
            orderGenerali3.Type = 'New';
            orderGenerali3.Status = 'CarriedOut';
            orderGenerali3.EffectiveDate = Date.today();
            orderGenerali3.DateOfFirstInstallment__c = Date.today();
            orderGenerali3.PoDate = Date.today();
            orderGenerali3.EndDate = Date.today() + 1;
            orderGenerali3.NumberOfInstallments__c = '1';
            orderGenerali3.RecordTypeId = corporateApoliceRecordType;
            orderGenerali3.AccountId = acc.Id;

            insert orderGenerali3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Order orderHDI = new Order();
        orderHDI.Name = TestDataFactory.generateRandomStringNumber(10);
        orderHDI.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderHDI.PoNumber = '01.030.131.012962.000000 - 1';
        orderHDI.Company__c = 'HDI Seguros';
        orderHDI.Type = 'New';
        orderHDI.Status = 'CarriedOut';
        orderHDI.EffectiveDate = Date.today();
        orderHDI.DateOfFirstInstallment__c = Date.today();
        orderHDI.PoDate = Date.today();
        orderHDI.EndDate = Date.today() + 1;
        orderHDI.NumberOfInstallments__c = '1';
        orderHDI.RecordTypeId = corporateApoliceRecordType;
        orderHDI.AccountId = acc.Id;

        insert orderHDI;

        Order orderHDI2 = new Order();
        orderHDI2.Name = TestDataFactory.generateRandomStringNumber(10);
        orderHDI2.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderHDI2.PoNumber = '12362';
        orderHDI2.Company__c = 'HDI Seguros';
        orderHDI2.Type = 'New';
        orderHDI2.Status = 'CarriedOut';
        orderHDI2.EffectiveDate = Date.today();
        orderHDI2.DateOfFirstInstallment__c = Date.today();
        orderHDI2.PoDate = Date.today();
        orderHDI2.EndDate = Date.today() + 1;
        orderHDI2.NumberOfInstallments__c = '1';
        orderHDI2.RecordTypeId = corporateApoliceRecordType;
        orderHDI2.AccountId = acc.Id;

        insert orderHDI2;

         try{
            Order orderHDI3 = new Order();
            orderHDI3.Name = TestDataFactory.generateRandomStringNumber(10);
            orderHDI3.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
            orderHDI3.PoNumber = '4';
            orderHDI3.Company__c = 'HDI Seguros';
            orderHDI3.Type = 'New';
            orderHDI3.Status = 'CarriedOut';
            orderHDI3.EffectiveDate = Date.today();
            orderHDI3.DateOfFirstInstallment__c = Date.today();
            orderHDI3.PoDate = Date.today();
            orderHDI3.EndDate = Date.today() + 1;
            orderHDI3.NumberOfInstallments__c = '1';
            orderHDI3.RecordTypeId = corporateApoliceRecordType;
            orderHDI3.AccountId = acc.Id;

            insert orderHDI3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Order orderKovrSeguradora = new Order();
        orderKovrSeguradora.Name = TestDataFactory.generateRandomStringNumber(10);
        orderKovrSeguradora.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderKovrSeguradora.PoNumber = '011.1004600005115';
        orderKovrSeguradora.Company__c = 'Kovr Seguradora S/A';
        orderKovrSeguradora.Type = 'New';
        orderKovrSeguradora.Status = 'CarriedOut';
        orderKovrSeguradora.EffectiveDate = Date.today();
        orderKovrSeguradora.DateOfFirstInstallment__c = Date.today();
        orderKovrSeguradora.PoDate = Date.today();
        orderKovrSeguradora.EndDate = Date.today() + 1;
        orderKovrSeguradora.NumberOfInstallments__c = '1';
        orderKovrSeguradora.RecordTypeId = corporateApoliceRecordType;
        orderKovrSeguradora.AccountId = acc.Id;

        insert orderKovrSeguradora;

        Order orderKovrSeguradora2 = new Order();
        orderKovrSeguradora2.Name = TestDataFactory.generateRandomStringNumber(10);
        orderKovrSeguradora2.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderKovrSeguradora2.PoNumber = '1005600005115';
        orderKovrSeguradora2.Company__c = 'Kovr Seguradora S/A';
        orderKovrSeguradora2.Type = 'New';
        orderKovrSeguradora2.Status = 'CarriedOut';
        orderKovrSeguradora2.EffectiveDate = Date.today();
        orderKovrSeguradora2.DateOfFirstInstallment__c = Date.today();
        orderKovrSeguradora2.PoDate = Date.today();
        orderKovrSeguradora2.EndDate = Date.today() + 1;
        orderKovrSeguradora2.NumberOfInstallments__c = '1';
        orderKovrSeguradora2.RecordTypeId = corporateApoliceRecordType;
        orderKovrSeguradora2.AccountId = acc.Id;

        insert orderKovrSeguradora2;

        // Order orderKovrSeguradora3 = new Order();
        // orderKovrSeguradora3.Name = TestDataFactory.generateRandomStringNumber(10);
        // orderKovrSeguradora3.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        // orderKovrSeguradora3.PoNumber = '1005600005112315';
        // orderKovrSeguradora3.Company__c = 'Kovr Seguradora S/A';
        // orderKovrSeguradora3.Type = 'New';
        // orderKovrSeguradora3.Status = 'CarriedOut';
        // orderKovrSeguradora3.EffectiveDate = Date.today();
        // orderKovrSeguradora3.DateOfFirstInstallment__c = Date.today();
        // orderKovrSeguradora3.PoDate = Date.today();
        // orderKovrSeguradora3.EndDate = Date.today() + 1;
        // orderKovrSeguradora3.NumberOfInstallments__c = '1';
        // orderKovrSeguradora3.RecordTypeId = corporateApoliceRecordType;
        // orderKovrSeguradora3.AccountId = acc.Id;

        // insert orderKovrSeguradora3;

         try{
            Order orderKovrSeguradora4 = new Order();
            orderKovrSeguradora4.Name = TestDataFactory.generateRandomStringNumber(10);
            orderKovrSeguradora4.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
            orderKovrSeguradora4.PoNumber = '4';
            orderKovrSeguradora4.Company__c = 'Kovr Seguradora S/A';
            orderKovrSeguradora4.Type = 'New';
            orderKovrSeguradora4.Status = 'CarriedOut';
            orderKovrSeguradora4.EffectiveDate = Date.today();
            orderKovrSeguradora4.DateOfFirstInstallment__c = Date.today();
            orderKovrSeguradora4.PoDate = Date.today();
            orderKovrSeguradora4.EndDate = Date.today() + 1;
            orderKovrSeguradora4.NumberOfInstallments__c = '1';
            orderKovrSeguradora4.RecordTypeId = corporateApoliceRecordType;
            orderKovrSeguradora4.AccountId = acc.Id;

            insert orderKovrSeguradora4;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }
        Test.stopTest();
    }
    @isTest
    public static void processarPoNumber4Test(){
        Test.startTest();
        Account acc = AccountDataFactory.insertPersonAccount();
        Order orderItau = new Order();
        orderItau.Name = TestDataFactory.generateRandomStringNumber(10);
        orderItau.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderItau.PoNumber = '33.31.17811849.0';
        orderItau.Company__c = 'Itau Seguros';
        orderItau.Type = 'New';
        orderItau.Status = 'CarriedOut';
        orderItau.EffectiveDate = Date.today();
        orderItau.DateOfFirstInstallment__c = Date.today();
        orderItau.PoDate = Date.today();
        orderItau.EndDate = Date.today() + 1;
        orderItau.NumberOfInstallments__c = '1';
        orderItau.RecordTypeId = corporateApoliceRecordType;
        orderItau.AccountId = acc.Id;

        insert orderItau;

        Order orderItau2 = new Order();
        orderItau2.Name = TestDataFactory.generateRandomStringNumber(10);
        orderItau2.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderItau2.PoNumber = '17811840';
        orderItau2.Company__c = 'Itau Seguros';
        orderItau2.Type = 'New';
        orderItau2.Status = 'CarriedOut';
        orderItau2.EffectiveDate = Date.today();
        orderItau2.DateOfFirstInstallment__c = Date.today();
        orderItau2.PoDate = Date.today();
        orderItau2.EndDate = Date.today() + 1;
        orderItau2.NumberOfInstallments__c = '1';
        orderItau2.RecordTypeId = corporateApoliceRecordType;
        orderItau2.AccountId = acc.Id;

        insert orderItau2;

         try{
            Order orderItau3 = new Order();
            orderItau3.Name = TestDataFactory.generateRandomStringNumber(10);
            orderItau3.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
            orderItau3.PoNumber = '4';
            orderItau3.Company__c = 'Itau Seguros';
            orderItau3.Type = 'New';
            orderItau3.Status = 'CarriedOut';
            orderItau3.EffectiveDate = Date.today();
            orderItau3.DateOfFirstInstallment__c = Date.today();
            orderItau3.PoDate = Date.today();
            orderItau3.EndDate = Date.today() + 1;
            orderItau3.NumberOfInstallments__c = '1';
            orderItau3.RecordTypeId = corporateApoliceRecordType;
            orderItau3.AccountId = acc.Id;

            insert orderItau3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Order orderLiberty = new Order();
        orderLiberty.Name = TestDataFactory.generateRandomStringNumber(10);
        orderLiberty.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderLiberty.PoNumber = '67.94.003.551';
        orderLiberty.Company__c = 'Liberty Seguros';
        orderLiberty.Type = 'New';
        orderLiberty.Status = 'CarriedOut';
        orderLiberty.EffectiveDate = Date.today();
        orderLiberty.DateOfFirstInstallment__c = Date.today();
        orderLiberty.PoDate = Date.today();
        orderLiberty.EndDate = Date.today() + 1;
        orderLiberty.NumberOfInstallments__c = '1';
        orderLiberty.RecordTypeId = corporateApoliceRecordType;
        orderLiberty.AccountId = acc.Id;

        insert orderLiberty;

        Order orderLiberty2 = new Order();
        orderLiberty2.Name = TestDataFactory.generateRandomStringNumber(10);
        orderLiberty2.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderLiberty2.PoNumber = '6794003552';
        orderLiberty2.Company__c = 'Liberty Seguros';
        orderLiberty2.Type = 'New';
        orderLiberty2.Status = 'CarriedOut';
        orderLiberty2.EffectiveDate = Date.today();
        orderLiberty2.DateOfFirstInstallment__c = Date.today();
        orderLiberty2.PoDate = Date.today();
        orderLiberty2.EndDate = Date.today() + 1;
        orderLiberty2.NumberOfInstallments__c = '1';
        orderLiberty2.RecordTypeId = corporateApoliceRecordType;
        orderLiberty2.AccountId = acc.Id;

        insert orderLiberty2;

         try{
            Order orderLiberty3 = new Order();
            orderLiberty3.Name = TestDataFactory.generateRandomStringNumber(10);
            orderLiberty3.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
            orderLiberty3.PoNumber = '4';
            orderLiberty3.Company__c = 'Liberty Seguros';
            orderLiberty3.Type = 'New';
            orderLiberty3.Status = 'CarriedOut';
            orderLiberty3.EffectiveDate = Date.today();
            orderLiberty3.DateOfFirstInstallment__c = Date.today();
            orderLiberty3.PoDate = Date.today();
            orderLiberty3.EndDate = Date.today() + 1;
            orderLiberty3.NumberOfInstallments__c = '1';
            orderLiberty3.RecordTypeId = corporateApoliceRecordType;
            orderLiberty3.AccountId = acc.Id;

            insert orderLiberty3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Order orderMapfre = new Order();
        orderMapfre.Name = TestDataFactory.generateRandomStringNumber(10);
        orderMapfre.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderMapfre.PoNumber = '6924/0002223/62';
        orderMapfre.Company__c = 'Mapfre Vida';
        orderMapfre.Type = 'New';
        orderMapfre.Status = 'CarriedOut';
        orderMapfre.EffectiveDate = Date.today();
        orderMapfre.DateOfFirstInstallment__c = Date.today();
        orderMapfre.PoDate = Date.today();
        orderMapfre.EndDate = Date.today() + 1;
        orderMapfre.NumberOfInstallments__c = '1';
        orderMapfre.RecordTypeId = corporateApoliceRecordType;
        orderMapfre.AccountId = acc.Id;

        insert orderMapfre;

        Order orderMapfre2 = new Order();
        orderMapfre2.Name = TestDataFactory.generateRandomStringNumber(10);
        orderMapfre2.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderMapfre2.PoNumber = '6924000222361';
        orderMapfre2.Company__c = 'Mapfre Vida';
        orderMapfre2.Type = 'New';
        orderMapfre2.Status = 'CarriedOut';
        orderMapfre2.EffectiveDate = Date.today();
        orderMapfre2.DateOfFirstInstallment__c = Date.today();
        orderMapfre2.PoDate = Date.today();
        orderMapfre2.EndDate = Date.today() + 1;
        orderMapfre2.NumberOfInstallments__c = '1';
        orderMapfre2.RecordTypeId = corporateApoliceRecordType;
        orderMapfre2.AccountId = acc.Id;

        insert orderMapfre2;

         try{
            Order orderMapfre3 = new Order();
            orderMapfre3.Name = TestDataFactory.generateRandomStringNumber(10);
            orderMapfre3.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
            orderMapfre3.PoNumber = '4';
            orderMapfre3.Company__c = 'Mapfre Vida';
            orderMapfre3.Type = 'New';
            orderMapfre3.Status = 'CarriedOut';
            orderMapfre3.EffectiveDate = Date.today();
            orderMapfre3.DateOfFirstInstallment__c = Date.today();
            orderMapfre3.PoDate = Date.today();
            orderMapfre3.EndDate = Date.today() + 1;
            orderMapfre3.NumberOfInstallments__c = '1';
            orderMapfre3.RecordTypeId = corporateApoliceRecordType;
            orderMapfre3.AccountId = acc.Id;

            insert orderMapfre3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Order orderMetlife = new Order();
        orderMetlife.Name = TestDataFactory.generateRandomStringNumber(10);
        orderMetlife.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderMetlife.PoNumber = '69308001';
        orderMetlife.Company__c = 'MetLife';
        orderMetlife.Type = 'New';
        orderMetlife.Status = 'CarriedOut';
        orderMetlife.EffectiveDate = Date.today();
        orderMetlife.DateOfFirstInstallment__c = Date.today();
        orderMetlife.PoDate = Date.today();
        orderMetlife.EndDate = Date.today() + 1;
        orderMetlife.NumberOfInstallments__c = '1';
        orderMetlife.RecordTypeId = corporateApoliceRecordType;
        orderMetlife.AccountId = acc.Id;

        insert orderMetlife;

        Order orderMetlife2 = new Order();
        orderMetlife2.Name = TestDataFactory.generateRandomStringNumber(10);
        orderMetlife2.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderMetlife2.PoNumber = '69309';
        orderMetlife2.Company__c = 'MetLife';
        orderMetlife2.Type = 'New';
        orderMetlife2.Status = 'CarriedOut';
        orderMetlife2.EffectiveDate = Date.today();
        orderMetlife2.DateOfFirstInstallment__c = Date.today();
        orderMetlife2.PoDate = Date.today();
        orderMetlife2.EndDate = Date.today() + 1;
        orderMetlife2.NumberOfInstallments__c = '1';
        orderMetlife2.RecordTypeId = corporateApoliceRecordType;
        orderMetlife2.AccountId = acc.Id;

        insert orderMetlife2;

         try{
            Order orderMetlife3 = new Order();
            orderMetlife3.Name = TestDataFactory.generateRandomStringNumber(10);
            orderMetlife3.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
            orderMetlife3.PoNumber = '4';
            orderMetlife3.Company__c = 'MetLife';
            orderMetlife3.Type = 'New';
            orderMetlife3.Status = 'CarriedOut';
            orderMetlife3.EffectiveDate = Date.today();
            orderMetlife3.DateOfFirstInstallment__c = Date.today();
            orderMetlife3.PoDate = Date.today();
            orderMetlife3.EndDate = Date.today() + 1;
            orderMetlife3.NumberOfInstallments__c = '1';
            orderMetlife3.RecordTypeId = corporateApoliceRecordType;
            orderMetlife3.AccountId = acc.Id;

            insert orderMetlife3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Order orderMitsui = new Order();
        orderMitsui.Name = TestDataFactory.generateRandomStringNumber(10);
        orderMitsui.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderMitsui.PoNumber = '01180072655';
        orderMitsui.Company__c = 'Mitsui Sumitomo Seguros';
        orderMitsui.Type = 'New';
        orderMitsui.Status = 'CarriedOut';
        orderMitsui.EffectiveDate = Date.today();
        orderMitsui.DateOfFirstInstallment__c = Date.today();
        orderMitsui.PoDate = Date.today();
        orderMitsui.EndDate = Date.today() + 1;
        orderMitsui.NumberOfInstallments__c = '1';
        orderMitsui.RecordTypeId = corporateApoliceRecordType;
        orderMitsui.AccountId = acc.Id;

        insert orderMitsui;

        Order orderMitsui2 = new Order();
        orderMitsui2.Name = TestDataFactory.generateRandomStringNumber(10);
        orderMitsui2.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderMitsui2.PoNumber = '2180072655';
        orderMitsui2.Company__c = 'Mitsui Sumitomo Seguros';
        orderMitsui2.Type = 'New';
        orderMitsui2.Status = 'CarriedOut';
        orderMitsui2.EffectiveDate = Date.today();
        orderMitsui2.DateOfFirstInstallment__c = Date.today();
        orderMitsui2.PoDate = Date.today();
        orderMitsui2.EndDate = Date.today() + 1;
        orderMitsui2.NumberOfInstallments__c = '1';
        orderMitsui2.RecordTypeId = corporateApoliceRecordType;
        orderMitsui2.AccountId = acc.Id;

        insert orderMitsui2;

         try{
            Order orderMitsui3 = new Order();
            orderMitsui3.Name = TestDataFactory.generateRandomStringNumber(10);
            orderMitsui3.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
            orderMitsui3.PoNumber = '4';
            orderMitsui3.Company__c = 'Mitsui Sumitomo Seguros';
            orderMitsui3.Type = 'New';
            orderMitsui3.Status = 'CarriedOut';
            orderMitsui3.EffectiveDate = Date.today();
            orderMitsui3.DateOfFirstInstallment__c = Date.today();
            orderMitsui3.PoDate = Date.today();
            orderMitsui3.EndDate = Date.today() + 1;
            orderMitsui3.NumberOfInstallments__c = '1';
            orderMitsui3.RecordTypeId = corporateApoliceRecordType;
            orderMitsui3.AccountId = acc.Id;

            insert orderMitsui3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }
        Test.stopTest();
    }
  @isTest
    public static void processarPoNumberTest(){
        Test.startTest();
        Account acc = AccountDataFactory.insertPersonAccount();
        Order orderMagSeguros = new Order();
        orderMagSeguros.Name = TestDataFactory.generateRandomStringNumber(10);
        orderMagSeguros.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderMagSeguros.PoNumber = '2180072655';
        orderMagSeguros.Company__c = 'MAG Seguros';
        orderMagSeguros.Type = 'New';
        orderMagSeguros.Status = 'CarriedOut';
        orderMagSeguros.EffectiveDate = Date.today();
        orderMagSeguros.DateOfFirstInstallment__c = Date.today();
        orderMagSeguros.PoDate = Date.today();
        orderMagSeguros.EndDate = Date.today() + 1;
        orderMagSeguros.NumberOfInstallments__c = '1';
        orderMagSeguros.RecordTypeId = corporateApoliceRecordType;
        orderMagSeguros.AccountId = acc.Id;

        insert orderMagSeguros;

        Order orderMagSeguros2 = new Order();
        orderMagSeguros2.Name = TestDataFactory.generateRandomStringNumber(10);
        orderMagSeguros2.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderMagSeguros2.PoNumber = '52742';
        orderMagSeguros2.Company__c = 'MAG Seguros';
        orderMagSeguros2.Type = 'New';
        orderMagSeguros2.Status = 'CarriedOut';
        orderMagSeguros2.EffectiveDate = Date.today();
        orderMagSeguros2.DateOfFirstInstallment__c = Date.today();
        orderMagSeguros2.PoDate = Date.today();
        orderMagSeguros2.EndDate = Date.today() + 1;
        orderMagSeguros2.NumberOfInstallments__c = '1';
        orderMagSeguros2.RecordTypeId = corporateApoliceRecordType;
        orderMagSeguros2.AccountId = acc.Id;

        insert orderMagSeguros2;

         try{
            Order orderMagSeguros3 = new Order();
            orderMagSeguros3.Name = TestDataFactory.generateRandomStringNumber(10);
            orderMagSeguros3.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
            orderMagSeguros3.PoNumber = '4';
            orderMagSeguros3.Company__c = 'MAG Seguros';
            orderMagSeguros3.Type = 'New';
            orderMagSeguros3.Status = 'CarriedOut';
            orderMagSeguros3.EffectiveDate = Date.today();
            orderMagSeguros3.DateOfFirstInstallment__c = Date.today();
            orderMagSeguros3.PoDate = Date.today();
            orderMagSeguros3.EndDate = Date.today() + 1;
            orderMagSeguros3.NumberOfInstallments__c = '1';
            orderMagSeguros3.RecordTypeId = corporateApoliceRecordType;
            orderMagSeguros3.AccountId = acc.Id;

            insert orderMagSeguros3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Order orderNobre = new Order();
        orderNobre.Name = TestDataFactory.generateRandomStringNumber(10);
        orderNobre.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderNobre.PoNumber = '2001/96/00000036/0 ';
        orderNobre.Company__c = 'Nobre';
        orderNobre.Type = 'New';
        orderNobre.Status = 'CarriedOut';
        orderNobre.EffectiveDate = Date.today();
        orderNobre.DateOfFirstInstallment__c = Date.today();
        orderNobre.PoDate = Date.today();
        orderNobre.EndDate = Date.today() + 1;
        orderNobre.NumberOfInstallments__c = '1';
        orderNobre.RecordTypeId = corporateApoliceRecordType;
        orderNobre.AccountId = acc.Id;

        insert orderNobre;

        Order orderNobre2 = new Order();
        orderNobre2.Name = TestDataFactory.generateRandomStringNumber(10);
        orderNobre2.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderNobre2.PoNumber = '38';
        orderNobre2.Company__c = 'Nobre';
        orderNobre2.Type = 'New';
        orderNobre2.Status = 'CarriedOut';
        orderNobre2.EffectiveDate = Date.today();
        orderNobre2.DateOfFirstInstallment__c = Date.today();
        orderNobre2.PoDate = Date.today();
        orderNobre2.EndDate = Date.today() + 1;
        orderNobre2.NumberOfInstallments__c = '1';
        orderNobre2.RecordTypeId = corporateApoliceRecordType;
        orderNobre2.AccountId = acc.Id;

        insert orderNobre2;

         try{
            Order orderNobre3 = new Order();
            orderNobre3.Name = TestDataFactory.generateRandomStringNumber(10);
            orderNobre3.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
            orderNobre3.PoNumber = '4';
            orderNobre3.Company__c = 'Nobre';
            orderNobre3.Type = 'New';
            orderNobre3.Status = 'CarriedOut';
            orderNobre3.EffectiveDate = Date.today();
            orderNobre3.DateOfFirstInstallment__c = Date.today();
            orderNobre3.PoDate = Date.today();
            orderNobre3.EndDate = Date.today() + 1;
            orderNobre3.NumberOfInstallments__c = '1';
            orderNobre3.RecordTypeId = corporateApoliceRecordType;
            orderNobre3.AccountId = acc.Id;

            insert orderNobre3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Order orderPorto = new Order();
        orderPorto.Name = TestDataFactory.generateRandomStringNumber(10);
        orderPorto.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderPorto.PoNumber = '0118.11.54.779-9';
        orderPorto.Company__c = 'Porto Seguro';
        orderPorto.Type = 'New';
        orderPorto.Status = 'CarriedOut';
        orderPorto.EffectiveDate = Date.today();
        orderPorto.DateOfFirstInstallment__c = Date.today();
        orderPorto.PoDate = Date.today();
        orderPorto.EndDate = Date.today() + 1;
        orderPorto.NumberOfInstallments__c = '1';
        orderPorto.RecordTypeId = corporateApoliceRecordType;
        orderPorto.AccountId = acc.Id;

        insert orderPorto;

        Order orderPorto2 = new Order();
        orderPorto2.Name = TestDataFactory.generateRandomStringNumber(10);
        orderPorto2.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderPorto2.PoNumber = '4000068';
        orderPorto2.Company__c = 'Porto Seguro';
        orderPorto2.Type = 'New';
        orderPorto2.Status = 'CarriedOut';
        orderPorto2.EffectiveDate = Date.today();
        orderPorto2.DateOfFirstInstallment__c = Date.today();
        orderPorto2.PoDate = Date.today();
        orderPorto2.EndDate = Date.today() + 1;
        orderPorto2.NumberOfInstallments__c = '1';
        orderPorto2.RecordTypeId = corporateApoliceRecordType;
        orderPorto2.AccountId = acc.Id;

        insert orderPorto2;

         try{
            Order orderPorto3 = new Order();
            orderPorto3.Name = TestDataFactory.generateRandomStringNumber(10);
            orderPorto3.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
            orderPorto3.PoNumber = '4';
            orderPorto3.Company__c = 'Porto Seguro';
            orderPorto3.Type = 'New';
            orderPorto3.Status = 'CarriedOut';
            orderPorto3.EffectiveDate = Date.today();
            orderPorto3.DateOfFirstInstallment__c = Date.today();
            orderPorto3.PoDate = Date.today();
            orderPorto3.EndDate = Date.today() + 1;
            orderPorto3.NumberOfInstallments__c = '1';
            orderPorto3.RecordTypeId = corporateApoliceRecordType;
            orderPorto3.AccountId = acc.Id;

            insert orderPorto3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }
        Test.stopTest();
    }
    @isTest
    public static void processarPoNumber6Test(){
        Test.startTest();
        Account acc = AccountDataFactory.insertPersonAccount();
        Order orderPottencial = new Order();
        orderPottencial.Name = TestDataFactory.generateRandomStringNumber(10);
        orderPottencial.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderPottencial.PoNumber = '0306920189907750240991000';
        orderPottencial.Company__c = 'Pottencial Seguradora';
        orderPottencial.Type = 'New';
        orderPottencial.Status = 'CarriedOut';
        orderPottencial.EffectiveDate = Date.today();
        orderPottencial.DateOfFirstInstallment__c = Date.today();
        orderPottencial.PoDate = Date.today();
        orderPottencial.EndDate = Date.today() + 1;
        orderPottencial.NumberOfInstallments__c = '1';
        orderPottencial.RecordTypeId = corporateApoliceRecordType;
        orderPottencial.AccountId = acc.Id;

        insert orderPottencial;

        Order orderPottencial2 = new Order();
        orderPottencial2.Name = TestDataFactory.generateRandomStringNumber(10);
        orderPottencial2.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderPottencial2.PoNumber = '0240992';
        orderPottencial2.Company__c = 'Pottencial Seguradora';
        orderPottencial2.Type = 'New';
        orderPottencial2.Status = 'CarriedOut';
        orderPottencial2.EffectiveDate = Date.today();
        orderPottencial2.DateOfFirstInstallment__c = Date.today();
        orderPottencial2.PoDate = Date.today();
        orderPottencial2.EndDate = Date.today() + 1;
        orderPottencial2.NumberOfInstallments__c = '1';
        orderPottencial2.RecordTypeId = corporateApoliceRecordType;
        orderPottencial2.AccountId = acc.Id;

        insert orderPottencial2;

        Order orderPottencial3 = new Order();
        orderPottencial3.Name = TestDataFactory.generateRandomStringNumber(10);
        orderPottencial3.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderPottencial3.PoNumber = '0306920189907760340991000';
        orderPottencial3.Company__c = 'Pottencial Seguradora';
        orderPottencial3.Type = 'New';
        orderPottencial3.Status = 'CarriedOut';
        orderPottencial3.EffectiveDate = Date.today();
        orderPottencial3.DateOfFirstInstallment__c = Date.today();
        orderPottencial3.PoDate = Date.today();
        orderPottencial3.EndDate = Date.today() + 1;
        orderPottencial3.NumberOfInstallments__c = '1';
        orderPottencial3.RecordTypeId = corporateApoliceRecordType;
        orderPottencial3.AccountId = acc.Id;

        insert orderPottencial3;

        Order orderPottencial4 = new Order();
        orderPottencial4.Name = TestDataFactory.generateRandomStringNumber(10);
        orderPottencial4.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderPottencial4.PoNumber = '0306920189907460699191110';
        orderPottencial4.Company__c = 'Pottencial Seguradora';
        orderPottencial4.Type = 'New';
        orderPottencial4.Status = 'CarriedOut';
        orderPottencial4.EffectiveDate = Date.today();
        orderPottencial4.DateOfFirstInstallment__c = Date.today();
        orderPottencial4.PoDate = Date.today();
        orderPottencial4.EndDate = Date.today() + 1;
        orderPottencial4.NumberOfInstallments__c = '1';
        orderPottencial4.RecordTypeId = corporateApoliceRecordType;
        orderPottencial4.AccountId = acc.Id;

        insert orderPottencial4;

        Order orderPottencial5 = new Order();
        orderPottencial5.Name = TestDataFactory.generateRandomStringNumber(10);
        orderPottencial5.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderPottencial5.PoNumber = '03069-20189907460640191000';
        orderPottencial5.Company__c = 'Pottencial Seguradora';
        orderPottencial5.Type = 'New';
        orderPottencial5.Status = 'CarriedOut';
        orderPottencial5.EffectiveDate = Date.today();
        orderPottencial5.DateOfFirstInstallment__c = Date.today();
        orderPottencial5.PoDate = Date.today();
        orderPottencial5.EndDate = Date.today() + 1;
        orderPottencial5.NumberOfInstallments__c = '1';
        orderPottencial5.RecordTypeId = corporateApoliceRecordType;
        orderPottencial5.AccountId = acc.Id;

        insert orderPottencial5;

        Order orderPottencial7 = new Order();
        orderPottencial7.Name = TestDataFactory.generateRandomStringNumber(10);
        orderPottencial7.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderPottencial7.PoNumber = '0306920219901670004141000';
        orderPottencial7.Company__c = 'Pottencial Seguradora';
        orderPottencial7.Type = 'New';
        orderPottencial7.Status = 'CarriedOut';
        orderPottencial7.EffectiveDate = Date.today();
        orderPottencial7.DateOfFirstInstallment__c = Date.today();
        orderPottencial7.PoDate = Date.today();
        orderPottencial7.EndDate = Date.today() + 1;
        orderPottencial7.NumberOfInstallments__c = '1';
        orderPottencial7.RecordTypeId = corporateApoliceRecordType;
        orderPottencial7.AccountId = acc.Id;

        insert orderPottencial7;

         try{
            Order orderPottencial6 = new Order();
            orderPottencial6.Name = TestDataFactory.generateRandomStringNumber(10);
            orderPottencial6.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
            orderPottencial6.PoNumber = '5';
            orderPottencial6.Company__c = 'Pottencial Seguradora';
            orderPottencial6.Type = 'New';
            orderPottencial6.Status = 'CarriedOut';
            orderPottencial6.EffectiveDate = Date.today();
            orderPottencial6.DateOfFirstInstallment__c = Date.today();
            orderPottencial6.PoDate = Date.today();
            orderPottencial6.EndDate = Date.today() + 1;
            orderPottencial6.NumberOfInstallments__c = '1';
            orderPottencial6.RecordTypeId = corporateApoliceRecordType;
            orderPottencial6.AccountId = acc.Id;

            insert orderPottencial6;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }
        Test.stopTest();
    }
    @isTest
    public static void processarPoNumber7Test(){
        Test.startTest();
        Account acc = AccountDataFactory.insertPersonAccount();

        Order orderSulAmerica = new Order();
        orderSulAmerica.Name = TestDataFactory.generateRandomStringNumber(10);
        orderSulAmerica.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderSulAmerica.PoNumber = '110310213215';
        orderSulAmerica.Company__c = 'SulAmérica';
        orderSulAmerica.Type = 'New';
        orderSulAmerica.Status = 'CarriedOut';
        orderSulAmerica.EffectiveDate = Date.today();
        orderSulAmerica.DateOfFirstInstallment__c = Date.today();
        orderSulAmerica.PoDate = Date.today();
        orderSulAmerica.EndDate = Date.today() + 1;
        orderSulAmerica.NumberOfInstallments__c = '1';
        orderSulAmerica.RecordTypeId = corporateApoliceRecordType;
        orderSulAmerica.AccountId = acc.Id;


        Order orderSulAmerica2 = new Order();
        orderSulAmerica2.Name = TestDataFactory.generateRandomStringNumber(10);
        orderSulAmerica2.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderSulAmerica2.PoNumber = '3792399';
        orderSulAmerica2.Company__c = 'SulAmérica';
        orderSulAmerica2.Type = 'New';
        orderSulAmerica2.Status = 'CarriedOut';
        orderSulAmerica2.EffectiveDate = Date.today();
        orderSulAmerica2.DateOfFirstInstallment__c = Date.today();
        orderSulAmerica2.PoDate = Date.today();
        orderSulAmerica2.EndDate = Date.today() + 1;
        orderSulAmerica2.NumberOfInstallments__c = '1';
        orderSulAmerica2.RecordTypeId = corporateApoliceRecordType;
        orderSulAmerica2.AccountId = acc.Id;

        insert new List<Order>{orderSulAmerica,orderSulAmerica2};

         try{
            Order orderSulAmerica3 = new Order();
            orderSulAmerica3.Name = TestDataFactory.generateRandomStringNumber(10);
            orderSulAmerica3.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
            orderSulAmerica3.PoNumber = '4';
            orderSulAmerica3.Company__c = 'SulAmérica';
            orderSulAmerica3.Type = 'New';
            orderSulAmerica3.Status = 'CarriedOut';
            orderSulAmerica3.EffectiveDate = Date.today();
            orderSulAmerica3.DateOfFirstInstallment__c = Date.today();
            orderSulAmerica3.PoDate = Date.today();
            orderSulAmerica3.EndDate = Date.today() + 1;
            orderSulAmerica3.NumberOfInstallments__c = '1';
            orderSulAmerica3.RecordTypeId = corporateApoliceRecordType;
            orderSulAmerica3.AccountId = acc.Id;

            insert orderSulAmerica3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Order orderTokio = new Order();
        orderTokio.Name = TestDataFactory.generateRandomStringNumber(10);
        orderTokio.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderTokio.PoNumber = '61902017890407750008937';
        orderTokio.Company__c = 'Tokio Marine';
        orderTokio.Type = 'New';
        orderTokio.Status = 'CarriedOut';
        orderTokio.EffectiveDate = Date.today();
        orderTokio.DateOfFirstInstallment__c = Date.today();
        orderTokio.PoDate = Date.today();
        orderTokio.EndDate = Date.today() + 1;
        orderTokio.NumberOfInstallments__c = '1';
        orderTokio.RecordTypeId = corporateApoliceRecordType;
        orderTokio.AccountId = acc.Id;


        Order orderTokio2 = new Order();
        orderTokio2.Name = TestDataFactory.generateRandomStringNumber(10);
        orderTokio2.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderTokio2.PoNumber = '000 0000023071';
        orderTokio2.Company__c = 'Tokio Marine';
        orderTokio2.Type = 'New';
        orderTokio2.Status = 'CarriedOut';
        orderTokio2.EffectiveDate = Date.today();
        orderTokio2.DateOfFirstInstallment__c = Date.today();
        orderTokio2.PoDate = Date.today();
        orderTokio2.EndDate = Date.today() + 1;
        orderTokio2.NumberOfInstallments__c = '1';
        orderTokio2.RecordTypeId = corporateApoliceRecordType;
        orderTokio2.AccountId = acc.Id;


        Order orderTokio3 = new Order();
        orderTokio3.Name = TestDataFactory.generateRandomStringNumber(10);
        orderTokio3.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderTokio3.PoNumber = '02271';
        orderTokio3.Company__c = 'Tokio Marine';
        orderTokio3.Type = 'New';
        orderTokio3.Status = 'CarriedOut';
        orderTokio3.EffectiveDate = Date.today();
        orderTokio3.DateOfFirstInstallment__c = Date.today();
        orderTokio3.PoDate = Date.today();
        orderTokio3.EndDate = Date.today() + 1;
        orderTokio3.NumberOfInstallments__c = '1';
        orderTokio3.RecordTypeId = corporateApoliceRecordType;
        orderTokio3.AccountId = acc.Id;

        insert new List<Order>{orderTokio,orderTokio2,orderTokio3};

         try{
            Order orderTokio4 = new Order();
            orderTokio4.Name = TestDataFactory.generateRandomStringNumber(10);
            orderTokio4.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
            orderTokio4.PoNumber = '4';
            orderTokio4.Company__c = 'Tokio Marine';
            orderTokio4.Type = 'New';
            orderTokio4.Status = 'CarriedOut';
            orderTokio4.EffectiveDate = Date.today();
            orderTokio4.DateOfFirstInstallment__c = Date.today();
            orderTokio4.PoDate = Date.today();
            orderTokio4.EndDate = Date.today() + 1;
            orderTokio4.NumberOfInstallments__c = '1';
            orderTokio4.RecordTypeId = corporateApoliceRecordType;
            orderTokio4.AccountId = acc.Id;

            insert orderTokio4;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Order orderXI = new Order();
        orderXI.Name = TestDataFactory.generateRandomStringNumber(10);
        orderXI.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderXI.PoNumber = '01961000393';
        orderXI.Company__c = 'XI Seguros';
        orderXI.Type = 'New';
        orderXI.Status = 'CarriedOut';
        orderXI.EffectiveDate = Date.today();
        orderXI.DateOfFirstInstallment__c = Date.today();
        orderXI.PoDate = Date.today();
        orderXI.EndDate = Date.today() + 1;
        orderXI.NumberOfInstallments__c = '1';
        orderXI.RecordTypeId = corporateApoliceRecordType;
        orderXI.AccountId = acc.Id;


        Order orderXI2 = new Order();
        orderXI2.Name = TestDataFactory.generateRandomStringNumber(10);
        orderXI2.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderXI2.PoNumber = '2961000393';
        orderXI2.Company__c = 'XI Seguros';
        orderXI2.Type = 'New';
        orderXI2.Status = 'CarriedOut';
        orderXI2.EffectiveDate = Date.today();
        orderXI2.DateOfFirstInstallment__c = Date.today();
        orderXI2.PoDate = Date.today();
        orderXI2.EndDate = Date.today() + 1;
        orderXI2.NumberOfInstallments__c = '1';
        orderXI2.RecordTypeId = corporateApoliceRecordType;
        orderXI2.AccountId = acc.Id;

        insert new List<Order>{orderXI,orderXI2};

         try{
            Order orderXI3 = new Order();
            orderXI3.Name = TestDataFactory.generateRandomStringNumber(10);
            orderXI3.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
            orderXI3.PoNumber = '4';
            orderXI3.Company__c = 'XI Seguros';
            orderXI3.Type = 'New';
            orderXI3.Status = 'CarriedOut';
            orderXI3.EffectiveDate = Date.today();
            orderXI3.DateOfFirstInstallment__c = Date.today();
            orderXI3.PoDate = Date.today();
            orderXI3.EndDate = Date.today() + 1;
            orderXI3.NumberOfInstallments__c = '1';
            orderXI3.RecordTypeId = corporateApoliceRecordType;
            orderXI3.AccountId = acc.Id;

            insert orderXI3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Order orderZurich = new Order();
        orderZurich.Name = TestDataFactory.generateRandomStringNumber(10);
        orderZurich.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderZurich.PoNumber = '054952020005407460000121';
        orderZurich.Company__c = 'Zurich';
        orderZurich.Type = 'New';
        orderZurich.Status = 'CarriedOut';
        orderZurich.EffectiveDate = Date.today();
        orderZurich.DateOfFirstInstallment__c = Date.today();
        orderZurich.PoDate = Date.today();
        orderZurich.EndDate = Date.today() + 1;
        orderZurich.NumberOfInstallments__c = '1';
        orderZurich.RecordTypeId = corporateApoliceRecordType;
        orderZurich.AccountId = acc.Id;


        Order orderZurich2 = new Order();
        orderZurich2.Name = TestDataFactory.generateRandomStringNumber(10);
        orderZurich2.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderZurich2.PoNumber = '12345';
        orderZurich2.Company__c = 'Zurich';
        orderZurich2.Type = 'New';
        orderZurich2.Status = 'CarriedOut';
        orderZurich2.EffectiveDate = Date.today();
        orderZurich2.DateOfFirstInstallment__c = Date.today();
        orderZurich2.PoDate = Date.today();
        orderZurich2.EndDate = Date.today() + 1;
        orderZurich2.NumberOfInstallments__c = '1';
        orderZurich2.RecordTypeId = corporateApoliceRecordType;
        orderZurich2.AccountId = acc.Id;

        insert new List<Order>{orderZurich,orderZurich2};

         try{
            Order orderZurich3 = new Order();
            orderZurich3.Name = TestDataFactory.generateRandomStringNumber(10);
            orderZurich3.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
            orderZurich3.PoNumber = '4';
            orderZurich3.Company__c = 'Zurich';
            orderZurich3.Type = 'New';
            orderZurich3.Status = 'CarriedOut';
            orderZurich3.EffectiveDate = Date.today();
            orderZurich3.DateOfFirstInstallment__c = Date.today();
            orderZurich3.PoDate = Date.today();
            orderZurich3.EndDate = Date.today() + 1;
            orderZurich3.NumberOfInstallments__c = '1';
            orderZurich3.RecordTypeId = corporateApoliceRecordType;
            orderZurich3.AccountId = acc.Id;

            insert orderZurich3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Order orderBTG = new Order();
        orderBTG.Name = TestDataFactory.generateRandomStringNumber(10);
        orderBTG.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderBTG.PoNumber = '017412016000107750000053';
        orderBTG.Company__c = 'Btg Pactual';
        orderBTG.Type = 'New';
        orderBTG.Status = 'CarriedOut';
        orderBTG.EffectiveDate = Date.today();
        orderBTG.DateOfFirstInstallment__c = Date.today();
        orderBTG.PoDate = Date.today();
        orderBTG.EndDate = Date.today() + 1;
        orderBTG.NumberOfInstallments__c = '1';
        orderBTG.RecordTypeId = corporateApoliceRecordType;
        orderBTG.AccountId = acc.Id;


        Order orderBTG2 = new Order();
        orderBTG2.Name = TestDataFactory.generateRandomStringNumber(10);
        orderBTG2.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderBTG2.PoNumber = '107750000054';
        orderBTG2.Company__c = 'Btg Pactual';
        orderBTG2.Type = 'New';
        orderBTG2.Status = 'CarriedOut';
        orderBTG2.EffectiveDate = Date.today();
        orderBTG2.DateOfFirstInstallment__c = Date.today();
        orderBTG2.PoDate = Date.today();
        orderBTG2.EndDate = Date.today() + 1;
        orderBTG2.NumberOfInstallments__c = '1';
        orderBTG2.RecordTypeId = corporateApoliceRecordType;
        orderBTG2.AccountId = acc.Id;

        insert new List<Order>{orderBTG,orderBTG2};

         try{
            Order orderBTG3 = new Order();
            orderBTG3.Name = TestDataFactory.generateRandomStringNumber(10);
            orderBTG3.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
            orderBTG3.PoNumber = '4';
            orderBTG3.Company__c = 'Btg Pactual';
            orderBTG3.Type = 'New';
            orderBTG3.Status = 'CarriedOut';
            orderBTG3.EffectiveDate = Date.today();
            orderBTG3.DateOfFirstInstallment__c = Date.today();
            orderBTG3.PoDate = Date.today();
            orderBTG3.EndDate = Date.today() + 1;
            orderBTG3.NumberOfInstallments__c = '1';
            orderBTG3.RecordTypeId = corporateApoliceRecordType;
            orderBTG3.AccountId = acc.Id;

            insert orderBTG3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Order orderReturn = new Order();
        orderReturn.Name = TestDataFactory.generateRandomStringNumber(10);
        orderReturn.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderReturn.PoNumber = '54321';
        orderReturn.Company__c = 'Zurich';
        orderReturn.Type = 'New';
        orderReturn.Status = 'CarriedOut';
        orderReturn.EffectiveDate = Date.today();
        orderReturn.DateOfFirstInstallment__c = Date.today();
        orderReturn.PoDate = Date.today();
        orderReturn.EndDate = Date.today() + 1;
        orderReturn.NumberOfInstallments__c = '1';
        orderReturn.RecordTypeId = corporateEndossoNeutroRecordType;
        orderReturn.AccountId = acc.Id;

        insert orderReturn;
        Test.stopTest();
        System.assertEquals('322441000', Corporate_OrderBO.leftZeroesTrim('00000322441000'), 'Quantidade de números incorreta');
        System.assertEquals('', Corporate_OrderBO.leftZeroesTrim(''), 'Quantidade de números incorreta');
    }

    @isTest
    public static void testOrderBOFairFax(){

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

        Order orderFairfax2 = new Order();
        orderFairfax2.Name = TestDataFactory.generateRandomStringNumber(10);
        orderFairfax2.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
        orderFairfax2.PoNumber = '1004600000159';
        orderFairfax2.Company__c = 'Fairfax';
        orderFairfax2.Type = 'New';
        orderFairfax2.Status = 'CarriedOut';
        orderFairfax2.EffectiveDate = Date.today();
        orderFairfax2.DateOfFirstInstallment__c = Date.today();
        orderFairfax2.PoDate = Date.today();
        orderFairfax2.EndDate = Date.today() + 1;
        orderFairfax2.NumberOfInstallments__c = '1';
        orderFairfax2.RecordTypeId = corporateApoliceRecordType;
        orderFairfax2.AccountId = acc.Id;

        insert orderFairfax2;

        try{
            Order orderFairfax3 = new Order();
            orderFairfax3.Name = TestDataFactory.generateRandomStringNumber(10);
            orderFairfax3.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
            orderFairfax3.PoNumber = '4';
            orderFairfax3.Company__c = 'Fairfax';
            orderFairfax3.Type = 'New';
            orderFairfax3.Status = 'CarriedOut';
            orderFairfax3.EffectiveDate = Date.today();
            orderFairfax3.DateOfFirstInstallment__c = Date.today();
            orderFairfax3.PoDate = Date.today();
            orderFairfax3.EndDate = Date.today() + 1;
            orderFairfax3.NumberOfInstallments__c = '1';
            orderFairfax3.RecordTypeId = corporateApoliceRecordType;
            orderFairfax3.AccountId = acc.Id;

            insert orderFairfax3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Test.startTest();
        Order objOrder1 = [SELECT PoNumber, Company__c FROM Order Where Id =:orderFairfax.Id];
        Order objOrder2 = [SELECT PoNumber, Company__c FROM Order Where Id =:orderFairfax2.Id];

        String expected = '077500007189';
        String actual = objOrder1.PoNumber;

        String expected2 = '1004600000159';
        String actual2 = objOrder2.PoNumber;

       // System.assertEquals(expected,actual,'Quantidade de números incorreta para ' +
           // objOrder1.Company__c +
       //     ' por favor verifique o número do pedido de compra');

      //  System.assertEquals(expected2,actual2,'Quantidade de números incorreta para ' +
      //  objOrder2.Company__c +
       // ' por favor verifique o número do pedido de compra');

        try{
            Order orderFairfax3 = new Order();
            orderFairfax3.Name = TestDataFactory.generateRandomStringNumber(10);
            orderFairfax3.QuotationNumber__c = TestDataFactory.generateRandomStringChar(10);
            orderFairfax3.PoNumber = '4';
            orderFairfax3.Company__c = 'Fairfax';
            orderFairfax3.Type = 'New';
            orderFairfax3.Status = 'CarriedOut';
            orderFairfax3.EffectiveDate = Date.today();
            orderFairfax3.DateOfFirstInstallment__c = Date.today();
            orderFairfax3.PoDate = Date.today();
            orderFairfax3.EndDate = Date.today() + 1;
            orderFairfax3.NumberOfInstallments__c = '1';
            orderFairfax3.RecordTypeId = corporateApoliceRecordType;
            orderFairfax3.AccountId = acc.Id;

            insert orderFairfax3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }
        Test.stopTest();
    }
}