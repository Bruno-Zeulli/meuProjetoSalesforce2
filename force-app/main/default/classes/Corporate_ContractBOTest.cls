/**
* @description       :
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             :
* @last modified on  : 03-02-2021
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
* Modifications Log
* Ver   Date         Author                               Modification
* 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest
public class Corporate_ContractBOTest {
    private static Id recordTypeIdContract = Schema.SObjectType.Contract2__c.getRecordTypeInfosByDeveloperName()
    .get('SeguroCorporate')
    .getRecordTypeId();
    private static Id recordTypeIdContractInsurance = Schema.SObjectType.Contract2__c.getRecordTypeInfosByDeveloperName()
    .get('Insurance')
    .getRecordTypeId();

    @isTest
    public static void processarContractNumberTest(){
        List<Contract2__c> contractLst = new List<Contract2__c>();
        List<Contract2__c> ctrUpdateList = new List<Contract2__c>();

        Test.startTest();
        Account acc = AccountDataFactory.insertPersonAccount();
        Contract2__c contractAlfa = new Contract2__c();
        contractAlfa.Name = TestDataFactory.generateRandomStringNumber(10);
        contractAlfa.BidNumber__c = '2/93/2205';
        contractAlfa.ContractNumber__c = '2/93/2205';
        contractAlfa.Company__c = 'Alfa Seguros';
        contractAlfa.Status__c = 'Pendente';
        contractAlfa.StartDate__c = Date.today();
        contractAlfa.EndDate__c = Date.today() + 1;
        contractAlfa.RecordTypeId = recordTypeIdContract;
        contractAlfa.Account__c = acc.Id;

        contractLst.add(contractAlfa);

         try{

            Contract2__c contractAlfa2 = new Contract2__c();
            contractAlfa2.Name = TestDataFactory.generateRandomStringNumber(10);
            contractAlfa2.ContractNumber__c = '052';
            contractAlfa2.Company__c = 'Alfa Seguros';
            contractAlfa2.Status__c = 'Pendente';
            contractAlfa2.StartDate__c = Date.today();
            contractAlfa2.EndDate__c = Date.today() + 1;
            contractAlfa2.RecordTypeId = recordTypeIdContract;
            contractAlfa2.Account__c = acc.Id;


            insert contractAlfa2;
            contractAlfa2.BidNumber__c = contractAlfa2.ContractNumber__c;
            update contractAlfa2;

        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Contract2__c contractAIG = new Contract2__c();
        contractAIG.Name = TestDataFactory.generateRandomStringNumber(10);
        contractAIG.BidNumber__c = '087372017010378004672';
        contractAIG.ContractNumber__c = '087372017010378004672';
        contractAIG.Company__c = 'AIG Seguros';
        contractAIG.Status__c = 'Pendente';
        contractAIG.StartDate__c = Date.today();
        contractAIG.EndDate__c = Date.today() + 1;
        contractAIG.RecordTypeId = recordTypeIdContract;
        contractAIG.Account__c = acc.Id;

        contractLst.add(contractAIG);

        Contract2__c contractAIG2 = new Contract2__c();
        contractAIG2.Name = TestDataFactory.generateRandomStringNumber(10);
        contractAIG2.BidNumber__c = '10378114672';
        contractAIG2.ContractNumber__c = '10378114672';
        contractAIG2.Company__c = 'AIG Seguros';
        contractAIG2.Status__c = 'Pendente';
        contractAIG2.StartDate__c = Date.today();
        contractAIG2.EndDate__c = Date.today() + 1;
        contractAIG2.RecordTypeId = recordTypeIdContract;
        contractAIG2.Account__c = acc.Id;

        contractLst.add(contractAIG2);

         try{
            Contract2__c contractAIG3 = new Contract2__c();
            contractAIG3.Name = TestDataFactory.generateRandomStringNumber(10);
            contractAIG3.ContractNumber__c = '10378114672221';
            contractAIG3.Company__c = 'AIG Seguros';
            contractAIG3.Status__c = 'Pendente';
            contractAIG3.StartDate__c = Date.today();
            contractAIG3.EndDate__c = Date.today() + 1;
            contractAIG3.RecordTypeId = recordTypeIdContract;
            contractAIG3.Account__c = acc.Id;

            insert contractAIG3;

            contractAIG3.BidNumber__c = contractAIG3.ContractNumber__c;

            update contractAIG3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Contract2__c contractAmerica = new Contract2__c();
        contractAmerica.Name = TestDataFactory.generateRandomStringNumber(10);
        contractAmerica.BidNumber__c = '058192019010007750000020';
        contractAmerica.ContractNumber__c = '058192019010007750000020';
        contractAmerica.Company__c = 'American Life';
        contractAmerica.Status__c = 'Pendente';
        contractAmerica.StartDate__c = Date.today();
        contractAmerica.EndDate__c = Date.today() + 1;
        contractAmerica.RecordTypeId = recordTypeIdContract;
        contractAmerica.Account__c = acc.Id;

        contractLst.add(contractAmerica);

        Contract2__c contractAmerica3 = new Contract2__c();
        contractAmerica3.Name = TestDataFactory.generateRandomStringNumber(10);
        contractAmerica3.BidNumber__c = '1007500002020X';
        contractAmerica3.ContractNumber__c = '1007500002020X';
        contractAmerica3.Company__c = 'American Life';
        contractAmerica3.Status__c = 'Pendente';
        contractAmerica3.StartDate__c = Date.today();
        contractAmerica3.EndDate__c = Date.today() + 1;
        contractAmerica3.RecordTypeId = recordTypeIdContract;
        contractAmerica3.Account__c = acc.Id;

        contractLst.add(contractAmerica3);

         try{
            Contract2__c contractAmerica4 = new Contract2__c();
            contractAmerica4.Name = TestDataFactory.generateRandomStringNumber(10);
            contractAmerica4.ContractNumber__c = '020';
            contractAmerica4.Company__c = 'American Life';
            contractAmerica4.Status__c = 'Pendente';
            contractAmerica4.StartDate__c = Date.today();
            contractAmerica4.EndDate__c = Date.today() + 1;
            contractAmerica4.RecordTypeId = recordTypeIdContract;
            contractAmerica4.Account__c = acc.Id;

            insert contractAmerica4;
            contractAmerica4.BidNumber__c = contractAmerica4.ContractNumber__c;
            update contractAmerica4;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Contract2__c contractArgo = new Contract2__c();
        contractArgo.Name = TestDataFactory.generateRandomStringNumber(10);
        contractArgo.BidNumber__c = '02798.2019.01.0310.000034';
        contractArgo.ContractNumber__c = '02798.2019.01.0310.000034';
        contractArgo.Company__c = 'Argo Seguros';
        contractArgo.Status__c = 'Pendente';
        contractArgo.StartDate__c = Date.today();
        contractArgo.EndDate__c = Date.today() + 1;
        contractArgo.RecordTypeId = recordTypeIdContract;
        contractArgo.Account__c = acc.Id;

        contractLst.add(contractArgo);

        Contract2__c contractArgo2 = new Contract2__c();
        contractArgo2.Name = TestDataFactory.generateRandomStringNumber(10);
        contractArgo2.BidNumber__c = '027982019010310002034';
        contractArgo2.ContractNumber__c = '027982019010310002034';
        contractArgo2.Company__c = 'Argo Seguros';
        contractArgo2.Status__c = 'Pendente';
        contractArgo2.StartDate__c = Date.today();
        contractArgo2.EndDate__c = Date.today() + 1;
        contractArgo2.RecordTypeId = recordTypeIdContract;
        contractArgo2.Account__c = acc.Id;

        contractLst.add(contractArgo2);

         try{
            Contract2__c contractArgo3 = new Contract2__c();
            contractArgo3.Name = TestDataFactory.generateRandomStringNumber(10);
            contractArgo3.ContractNumber__c = '0279820002034';
            contractArgo3.Company__c = 'Argo Seguros';
            contractArgo3.Status__c = 'Pendente';
            contractArgo3.StartDate__c = Date.today();
            contractArgo3.EndDate__c = Date.today() + 1;
            contractArgo3.RecordTypeId = recordTypeIdContract;
            contractArgo3.Account__c = acc.Id;

            insert contractArgo3;
            contractArgo3.BidNumber__c = contractArgo3.ContractNumber__c;
            update contractArgo3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Contract2__c contractAustral = new Contract2__c();
        contractAustral.Name = TestDataFactory.generateRandomStringNumber(10);
        contractAustral.BidNumber__c = '027982019010310002034234';
        contractAustral.ContractNumber__c = '027982019010310002034234';
        contractAustral.Company__c = 'Austral Seguros';
        contractAustral.Status__c = 'Pendente';
        contractAustral.StartDate__c = Date.today();
        contractAustral.EndDate__c = Date.today() + 1;
        contractAustral.RecordTypeId = recordTypeIdContract;
        contractAustral.Account__c = acc.Id;

        contractLst.add(contractAustral);

        Contract2__c contractAustral2 = new Contract2__c();
        contractAustral2.Name = TestDataFactory.generateRandomStringNumber(10);
        contractAustral2.BidNumber__c = '002034234222';
        contractAustral2.ContractNumber__c = '002034234222';
        contractAustral2.Company__c = 'Austral Seguros';
        contractAustral2.Status__c = 'Pendente';
        contractAustral2.StartDate__c = Date.today();
        contractAustral2.EndDate__c = Date.today() + 1;
        contractAustral2.RecordTypeId = recordTypeIdContract;
        contractAustral2.Account__c = acc.Id;

        contractLst.add(contractAustral2);

         try{
            Contract2__c contractAustral3 = new Contract2__c();
            contractAustral3.Name = TestDataFactory.generateRandomStringNumber(10);
            contractAustral3.ContractNumber__c = '00203';
            contractAustral3.Company__c = 'Austral Seguros';
            contractAustral3.Status__c = 'Pendente';
            contractAustral3.StartDate__c = Date.today();
            contractAustral3.EndDate__c = Date.today() + 1;
            contractAustral3.RecordTypeId = recordTypeIdContract;
            contractAustral3.Account__c = acc.Id;

            insert contractAustral3;
            contractAustral3.BidNumber__c = contractAustral3.ContractNumber__c;
            update contractAustral3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        insert contractLst;
        for(Contract2__c ctr : contractLst){
            if(ctr.ContractNumber__c == null || ctr.ContractNumber__c == ''){
                ctr.ContractNumber__c = ctr.BidNumber__c;
                ctr.Status__c = 'Ativo';
                ctrUpdateList.add(ctr);
                System.debug('tamanho da lista de update' + ctrUpdateList.size());
            }
        }
        System.debug('tamanho da lista de update fora do IF' + ctrUpdateList.size());
        update ctrUpdateList;
        Test.stopTest();
    }

    @isTest
    public static void processarContractNumber2Test(){
        List<Contract2__c> contractLst = new List<Contract2__c>();
        List<Contract2__c> ctrUpdateList = new List<Contract2__c>();

        Test.startTest();
        Account acc = AccountDataFactory.insertPersonAccount();

        Contract2__c contractAazul = new Contract2__c();
        contractAazul.Name = TestDataFactory.generateRandomStringNumber(10);
        contractAazul.BidNumber__c = '16.19.0531.037406.000';
        contractAazul.ContractNumber__c = '16.19.0531.037406.000';
        contractAazul.Company__c = 'Azul Seguros';
        contractAazul.Status__c = 'Pendente';
        contractAazul.StartDate__c = Date.today();
        contractAazul.EndDate__c = Date.today() + 1;
        contractAazul.RecordTypeId = recordTypeIdContract;
        contractAazul.Account__c = acc.Id;

        contractLst.add(contractAazul);

        Contract2__c contractAazul2 = new Contract2__c();
        contractAazul2.Name = TestDataFactory.generateRandomStringNumber(10);
        contractAazul2.BidNumber__c = '17190531037406000';
        contractAazul2.ContractNumber__c = '17190531037406000';
        contractAazul2.Company__c = 'Azul Seguros';
        contractAazul2.Status__c = 'Pendente';
        contractAazul2.StartDate__c = Date.today();
        contractAazul2.EndDate__c = Date.today() + 1;
        contractAazul2.RecordTypeId = recordTypeIdContract;
        contractAazul2.Account__c = acc.Id;

        contractLst.add(contractAazul2);

         try{
            Contract2__c contractAazul3 = new Contract2__c();
            contractAazul3.Name = TestDataFactory.generateRandomStringNumber(10);
            contractAazul3.ContractNumber__c = '1037406000';
            contractAazul3.Company__c = 'Azul Seguros';
            contractAazul3.Status__c = 'Pendente';
            contractAazul3.StartDate__c = Date.today();
            contractAazul3.EndDate__c = Date.today() + 1;
            contractAazul3.RecordTypeId = recordTypeIdContract;
            contractAazul3.Account__c = acc.Id;

            insert contractAazul3;
            contractAazul3.BidNumber__c = contractAazul3.ContractNumber__c;
            update contractAazul3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Contract2__c contractAxa = new Contract2__c();
        contractAxa.Name = TestDataFactory.generateRandomStringNumber(10);
        contractAxa.BidNumber__c = '02852.2018.0062.0118.0005297';
        contractAxa.ContractNumber__c = '02852.2018.0062.0118.0005297';
        contractAxa.Company__c = 'Axa Seguros';
        contractAxa.Status__c = 'Pendente';
        contractAxa.StartDate__c = Date.today();
        contractAxa.EndDate__c = Date.today() + 1;
        contractAxa.RecordTypeId = recordTypeIdContract;
        contractAxa.Account__c = acc.Id;

        contractLst.add(contractAxa);

        Contract2__c contractAxa2 = new Contract2__c();
        contractAxa2.Name = TestDataFactory.generateRandomStringNumber(10);
        contractAxa2.BidNumber__c = '5298';
        contractAxa2.ContractNumber__c = '5298';
        contractAxa2.Company__c = 'Axa Seguros';
        contractAxa2.Status__c = 'Pendente';
        contractAxa2.StartDate__c = Date.today();
        contractAxa2.EndDate__c = Date.today() + 1;
        contractAxa2.RecordTypeId = recordTypeIdContract;
        contractAxa2.Account__c = acc.Id;

        contractLst.add(contractAxa2);

         try{
            Contract2__c contractAxa3 = new Contract2__c();
            contractAxa3.Name = TestDataFactory.generateRandomStringNumber(10);
            contractAxa3.ContractNumber__c = '8';
            contractAxa3.Company__c = 'Axa Seguros';
            contractAxa3.Status__c = 'Pendente';
            contractAxa3.StartDate__c = Date.today();
            contractAxa3.EndDate__c = Date.today() + 1;
            contractAxa3.RecordTypeId = recordTypeIdContract;
            contractAxa3.Account__c = acc.Id;

            insert contractAxa3;
            contractAxa3.BidNumber__c = contractAxa3.ContractNumber__c;
            update contractAxa3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Contract2__c contractBerkley = new Contract2__c();
        contractBerkley.Name = TestDataFactory.generateRandomStringNumber(10);
        contractBerkley.BidNumber__c = '014142018000307670021118';
        contractBerkley.ContractNumber__c = '014142018000307670021118';
        contractBerkley.Company__c = 'Berkley Seguros';
        contractBerkley.Status__c = 'Pendente';
        contractBerkley.StartDate__c = Date.today();
        contractBerkley.EndDate__c = Date.today() + 1;
        contractBerkley.RecordTypeId = recordTypeIdContract;
        contractBerkley.Account__c = acc.Id;

        contractLst.add(contractBerkley);

        Contract2__c contractBerkley2 = new Contract2__c();
        contractBerkley2.Name = TestDataFactory.generateRandomStringNumber(10);
        contractBerkley2.BidNumber__c = '1007500073209';
        contractBerkley2.ContractNumber__c = '1007500073209';
        contractBerkley2.Company__c = 'Berkley Seguros';
        contractBerkley2.Status__c = 'Pendente';
        contractBerkley2.StartDate__c = Date.today();
        contractBerkley2.EndDate__c = Date.today() + 1;
        contractBerkley2.RecordTypeId = recordTypeIdContract;
        contractBerkley2.Account__c = acc.Id;

        contractLst.add(contractBerkley2);

         try{
            Contract2__c contractBerkley3 = new Contract2__c();
            contractBerkley3.Name = TestDataFactory.generateRandomStringNumber(10);
            contractBerkley3.ContractNumber__c = '109';
            contractBerkley3.Company__c = 'Berkley Seguros';
            contractBerkley3.Status__c = 'Pendente';
            contractBerkley3.StartDate__c = Date.today();
            contractBerkley3.EndDate__c = Date.today() + 1;
            contractBerkley3.RecordTypeId = recordTypeIdContract;
            contractBerkley3.Account__c = acc.Id;

            insert contractBerkley3;
            contractBerkley3.BidNumber__c = contractBerkley3.ContractNumber__c;
            update contractBerkley3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Contract2__c contractBMG = new Contract2__c();
        contractBMG.Name = TestDataFactory.generateRandomStringNumber(10);
        contractBMG.BidNumber__c = '017412017000107750000685';
        contractBMG.ContractNumber__c = '017412017000107750000685';
        contractBMG.Company__c = 'BMG Seguros';
        contractBMG.Status__c = 'Pendente';
        contractBMG.StartDate__c = Date.today();
        contractBMG.EndDate__c = Date.today() + 1;
        contractBMG.RecordTypeId = recordTypeIdContract;
        contractBMG.Account__c = acc.Id;

        contractLst.add(contractBMG);

        Contract2__c contractBMG2 = new Contract2__c();
        contractBMG2.Name = TestDataFactory.generateRandomStringNumber(10);
        contractBMG2.BidNumber__c = '107750000686';
        contractBMG2.ContractNumber__c = '107750000686';
        contractBMG2.Company__c = 'BMG Seguros';
        contractBMG2.Status__c = 'Pendente';
        contractBMG2.StartDate__c = Date.today();
        contractBMG2.EndDate__c = Date.today() + 1;
        contractBMG2.RecordTypeId = recordTypeIdContract;
        contractBMG2.Account__c = acc.Id;

        contractLst.add(contractBMG2);
         try{
            Contract2__c contractBMG3 = new Contract2__c();
            contractBMG3.Name = TestDataFactory.generateRandomStringNumber(10);
            contractBMG3.ContractNumber__c = '1';
            contractBMG3.Company__c = 'BMG Seguros';
            contractBMG3.Status__c = 'Pendente';
            contractBMG3.StartDate__c = Date.today();
            contractBMG3.EndDate__c = Date.today() + 1;
            contractBMG3.RecordTypeId = recordTypeIdContract;
            contractBMG3.Account__c = acc.Id;

            insert contractBMG3;
            contractBMG3.BidNumber__c = contractBMG3.ContractNumber__c;
            update contractBMG3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Contract2__c contractBradesco = new Contract2__c();
        contractBradesco.Name = TestDataFactory.generateRandomStringNumber(10);
        contractBradesco.BidNumber__c = '0981.990.0244.015717';
        contractBradesco.ContractNumber__c = '0981.990.0244.015717';
        contractBradesco.Company__c = 'Bradesco Seguros';
        contractBradesco.Status__c = 'Pendente';
        contractBradesco.StartDate__c = Date.today();
        contractBradesco.EndDate__c = Date.today() + 1;
        contractBradesco.RecordTypeId = recordTypeIdContract;
        contractBradesco.Account__c = acc.Id;

        contractLst.add(contractBradesco);

        Contract2__c contractBradesco2 = new Contract2__c();
        contractBradesco2.Name = TestDataFactory.generateRandomStringNumber(10);
        contractBradesco2.BidNumber__c = '01522';
        contractBradesco2.ContractNumber__c = '01522';
        contractBradesco2.Company__c = 'Bradesco Seguros';
        contractBradesco2.Status__c = 'Pendente';
        contractBradesco2.StartDate__c = Date.today();
        contractBradesco2.EndDate__c = Date.today() + 1;
        contractBradesco2.RecordTypeId = recordTypeIdContract;
        contractBradesco2.Account__c = acc.Id;

        contractLst.add(contractBradesco2);

        Contract2__c contractBradesco3 = new Contract2__c();
        contractBradesco3.Name = TestDataFactory.generateRandomStringNumber(10);
        contractBradesco3.BidNumber__c = '015';
        contractBradesco3.ContractNumber__c = '015';
        contractBradesco3.Company__c = 'Bradesco Seguros';
        contractBradesco3.Status__c = 'Pendente';
        contractBradesco3.StartDate__c = Date.today();
        contractBradesco3.EndDate__c = Date.today() + 1;
        contractBradesco3.RecordTypeId = recordTypeIdContract;
        contractBradesco3.Account__c = acc.Id;

        contractLst.add(contractBradesco3);

         try{
            Contract2__c contractBradesco4 = new Contract2__c();
            contractBradesco4.Name = TestDataFactory.generateRandomStringNumber(10);
            contractBradesco4.ContractNumber__c = '01';
            contractBradesco4.Company__c = 'Bradesco Seguros';
            contractBradesco4.Status__c = 'Pendente';
            contractBradesco4.StartDate__c = Date.today();
            contractBradesco4.EndDate__c = Date.today() + 1;
            contractBradesco4.RecordTypeId = recordTypeIdContract;
            contractBradesco4.Account__c = acc.Id;

            insert contractBradesco4;
            contractBradesco4.BidNumber__c = contractBradesco4.ContractNumber__c;
            update contractBradesco4;
        } catch (Exception e){
            // System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        // insert contractLst;
        for(Contract2__c ctr : contractLst){
            if(ctr.ContractNumber__c == null || ctr.ContractNumber__c == ''){
                ctr.ContractNumber__c = ctr.BidNumber__c;
                ctr.Status__c = 'Ativo';
                ctrUpdateList.add(ctr);
                System.debug('tamanho da lista de update' + ctrUpdateList.size());
            }
        }
        System.debug('tamanho da lista de update fora do IF' + ctrUpdateList.size());
        update ctrUpdateList;
        Test.stopTest();
    }

    @isTest
    public static void processarContractNumber3Test(){
        List<Contract2__c> contractLst = new List<Contract2__c>();
        List<Contract2__c> ctrUpdateList = new List<Contract2__c>();

        Test.startTest();
        Account acc = AccountDataFactory.insertPersonAccount();

        Contract2__c contractCapemisa = new Contract2__c();
        contractCapemisa.Name = TestDataFactory.generateRandomStringNumber(10);
        contractCapemisa.BidNumber__c = '017412016000107750000053';
        contractCapemisa.ContractNumber__c = '017412016000107750000053';
        contractCapemisa.Company__c = 'Capemisa';
        contractCapemisa.Status__c = 'Pendente';
        contractCapemisa.StartDate__c = Date.today();
        contractCapemisa.EndDate__c = Date.today() + 1;
        contractCapemisa.RecordTypeId = recordTypeIdContract;
        contractCapemisa.Account__c = acc.Id;

        contractLst.add(contractCapemisa);

        Contract2__c contractCapemisa2 = new Contract2__c();
        contractCapemisa2.Name = TestDataFactory.generateRandomStringNumber(10);
        contractCapemisa2.BidNumber__c = '107750000054';
        contractCapemisa2.ContractNumber__c = '107750000054';
        contractCapemisa2.Company__c = 'Capemisa';
        contractCapemisa2.Status__c = 'Pendente';
        contractCapemisa2.StartDate__c = Date.today();
        contractCapemisa2.EndDate__c = Date.today() + 1;
        contractCapemisa2.RecordTypeId = recordTypeIdContract;
        contractCapemisa2.Account__c = acc.Id;

        contractLst.add(contractCapemisa2);

         try{
            Contract2__c contractCapemisa3 = new Contract2__c();
            contractCapemisa3.Name = TestDataFactory.generateRandomStringNumber(10);
            contractCapemisa3.ContractNumber__c = '4';
            contractCapemisa3.Company__c = 'Capemisa';
            contractCapemisa3.Status__c = 'Pendente';
            contractCapemisa3.StartDate__c = Date.today();
            contractCapemisa3.EndDate__c = Date.today() + 1;
            contractCapemisa3.RecordTypeId = recordTypeIdContract;
            contractCapemisa3.Account__c = acc.Id;

            insert contractCapemisa3;
            contractCapemisa3.BidNumber__c = contractCapemisa3.ContractNumber__c;
            update contractCapemisa3;
        } catch (Exception e){
            // System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }



        Contract2__c contractCescebrasil = new Contract2__c();
        contractCescebrasil.Name = TestDataFactory.generateRandomStringNumber(10);
        contractCescebrasil.BidNumber__c = '069982019000207750035629';
        contractCescebrasil.ContractNumber__c = '069982019000207750035629';
        contractCescebrasil.Company__c = 'Cescebrasil';
        contractCescebrasil.Status__c = 'Pendente';
        contractCescebrasil.StartDate__c = Date.today();
        contractCescebrasil.EndDate__c = Date.today() + 1;
        contractCescebrasil.RecordTypeId = recordTypeIdContract;
        contractCescebrasil.Account__c = acc.Id;

        contractLst.add(contractCescebrasil);

        Contract2__c contractCescebrasil2 = new Contract2__c();
        contractCescebrasil2.Name = TestDataFactory.generateRandomStringNumber(10);
        contractCescebrasil2.BidNumber__c = '1004900000348';
        contractCescebrasil2.ContractNumber__c = '1004900000348';
        contractCescebrasil2.Company__c = 'Cescebrasil';
        contractCescebrasil2.Status__c = 'Pendente';
        contractCescebrasil2.StartDate__c = Date.today();
        contractCescebrasil2.EndDate__c = Date.today() + 1;
        contractCescebrasil2.RecordTypeId = recordTypeIdContract;
        contractCescebrasil2.Account__c = acc.Id;

        contractLst.add(contractCescebrasil2);

         try{
            Contract2__c contractCescebrasil3 = new Contract2__c();
            contractCescebrasil3.Name = TestDataFactory.generateRandomStringNumber(10);
            contractCescebrasil3.ContractNumber__c = '4';
            contractCescebrasil3.Company__c = 'Cescebrasil';
            contractCescebrasil3.Status__c = 'Pendente';
            contractCescebrasil3.StartDate__c = Date.today();
            contractCescebrasil3.EndDate__c = Date.today() + 1;
            contractCescebrasil3.RecordTypeId = recordTypeIdContract;
            contractCescebrasil3.Account__c = acc.Id;

            insert contractCescebrasil3;
            contractCescebrasil3.BidNumber__c = contractCescebrasil3.ContractNumber__c;
            update contractCescebrasil3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Contract2__c contractChubb = new Contract2__c();
        contractChubb.Name = TestDataFactory.generateRandomStringNumber(10);
        contractChubb.BidNumber__c = '1.180.011.365';
        contractChubb.ContractNumber__c = '1.180.011.365';
        contractChubb.Company__c = 'Chubb Seguros';
        contractChubb.Status__c = 'Pendente';
        contractChubb.StartDate__c = Date.today();
        contractChubb.EndDate__c = Date.today() + 1;
        contractChubb.RecordTypeId = recordTypeIdContract;
        contractChubb.Account__c = acc.Id;

        contractLst.add(contractChubb);

        Contract2__c contractChubb2 = new Contract2__c();
        contractChubb2.Name = TestDataFactory.generateRandomStringNumber(10);
        contractChubb2.BidNumber__c = '1180011465';
        contractChubb2.ContractNumber__c = '1180011465';
        contractChubb2.Company__c = 'Chubb Seguros';
        contractChubb2.Status__c = 'Pendente';
        contractChubb2.StartDate__c = Date.today();
        contractChubb2.EndDate__c = Date.today() + 1;
        contractChubb2.RecordTypeId = recordTypeIdContract;
        contractChubb2.Account__c = acc.Id;

        contractLst.add(contractChubb2);

         try{
            Contract2__c contractChubb3 = new Contract2__c();
            contractChubb3.Name = TestDataFactory.generateRandomStringNumber(10);
            contractChubb3.ContractNumber__c = '4';
            contractChubb3.Company__c = 'Chubb Seguros';
            contractChubb3.Status__c = 'Pendente';
            contractChubb3.StartDate__c = Date.today();
            contractChubb3.EndDate__c = Date.today() + 1;
            contractChubb3.RecordTypeId = recordTypeIdContract;
            contractChubb3.Account__c = acc.Id;

            insert contractChubb3;
            contractChubb3.BidNumber__c = contractChubb3.ContractNumber__c;
            update contractChubb3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Contract2__c contractExcelsior = new Contract2__c();
        contractExcelsior.Name = TestDataFactory.generateRandomStringNumber(10);
        contractExcelsior.BidNumber__c = '02710005520';
        contractExcelsior.ContractNumber__c = '02710005520';
        contractExcelsior.Company__c = 'Excelsior Seguros';
        contractExcelsior.Status__c = 'Pendente';
        contractExcelsior.StartDate__c = Date.today();
        contractExcelsior.EndDate__c = Date.today() + 1;
        contractExcelsior.RecordTypeId = recordTypeIdContract;
        contractExcelsior.Account__c = acc.Id;

        contractLst.add(contractExcelsior);

        Contract2__c contractExcelsior2 = new Contract2__c();
        contractExcelsior2.Name = TestDataFactory.generateRandomStringNumber(10);
        contractExcelsior2.BidNumber__c = '2720005520';
        contractExcelsior2.ContractNumber__c = '2720005520';
        contractExcelsior2.Company__c = 'Excelsior Seguros';
        contractExcelsior2.Status__c = 'Pendente';
        contractExcelsior2.StartDate__c = Date.today();
        contractExcelsior2.EndDate__c = Date.today() + 1;
        contractExcelsior2.RecordTypeId = recordTypeIdContract;
        contractExcelsior2.Account__c = acc.Id;

        contractLst.add(contractExcelsior2);

         try{
            Contract2__c contractExcelsior3 = new Contract2__c();
            contractExcelsior3.Name = TestDataFactory.generateRandomStringNumber(10);
            contractExcelsior3.ContractNumber__c = '4';
            contractExcelsior3.Company__c = 'Excelsior Seguros';
            contractExcelsior3.Status__c = 'Pendente';
            contractExcelsior3.StartDate__c = Date.today();
            contractExcelsior3.EndDate__c = Date.today() + 1;
            contractExcelsior3.RecordTypeId = recordTypeIdContract;
            contractExcelsior3.Account__c = acc.Id;

            insert contractExcelsior3;
            contractExcelsior3.BidNumber__c = contractExcelsior3.ContractNumber__c;
            update contractExcelsior3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Contract2__c contractEzze = new Contract2__c();
        contractEzze.Name = TestDataFactory.generateRandomStringNumber(10);
        contractEzze.BidNumber__c = '036462019000107757000068';
        contractEzze.ContractNumber__c = '036462019000107757000068';
        contractEzze.Company__c = 'Ezze Seguros';
        contractEzze.Status__c = 'Pendente';
        contractEzze.StartDate__c = Date.today();
        contractEzze.EndDate__c = Date.today() + 1;
        contractEzze.RecordTypeId = recordTypeIdContract;
        contractEzze.Account__c = acc.Id;

        contractLst.add(contractEzze);

        Contract2__c contractEzze2 = new Contract2__c();
        contractEzze2.Name = TestDataFactory.generateRandomStringNumber(10);
        contractEzze2.BidNumber__c = '1007507000013';
        contractEzze2.ContractNumber__c = '1007507000013';
        contractEzze2.Company__c = 'Ezze Seguros';
        contractEzze2.Status__c = 'Pendente';
        contractEzze2.StartDate__c = Date.today();
        contractEzze2.EndDate__c = Date.today() + 1;
        contractEzze2.RecordTypeId = recordTypeIdContract;
        contractEzze2.Account__c = acc.Id;

        contractLst.add(contractEzze2);

         try{
            Contract2__c contractEzze3 = new Contract2__c();
            contractEzze3.Name = TestDataFactory.generateRandomStringNumber(10);
            contractEzze3.ContractNumber__c = '4';
            contractEzze3.Company__c = 'Ezze Seguros';
            contractEzze3.Status__c = 'Pendente';
            contractEzze3.StartDate__c = Date.today();
            contractEzze3.EndDate__c = Date.today() + 1;
            contractEzze3.RecordTypeId = recordTypeIdContract;
            contractEzze3.Account__c = acc.Id;

            insert contractEzze3;
            contractEzze3.BidNumber__c = contractEzze3.ContractNumber__c;
            update contractEzze3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        insert contractLst;
        for(Contract2__c ctr : contractLst){
            if(ctr.ContractNumber__c == null || ctr.ContractNumber__c == ''){
                ctr.ContractNumber__c = ctr.BidNumber__c;
                ctr.Status__c = 'Ativo';
                ctrUpdateList.add(ctr);
                System.debug('tamanho da lista de update' + ctrUpdateList.size());
            }
        }
        System.debug('tamanho da lista de update fora do IF' + ctrUpdateList.size());
        update ctrUpdateList;
        Test.stopTest();
    }

    @isTest
    public static void processarContractNumber4Test(){
        List<Contract2__c> contractLst = new List<Contract2__c>();
        List<Contract2__c> ctrUpdateList = new List<Contract2__c>();

        Test.startTest();
        Account acc = AccountDataFactory.insertPersonAccount();

        Contract2__c contractFairfax = new Contract2__c();
        contractFairfax.Name = TestDataFactory.generateRandomStringNumber(10);
        contractFairfax.BidNumber__c = '0566920181001077500007189';
        contractFairfax.ContractNumber__c = '0566920181001077500007189';
        contractFairfax.Company__c = 'Fairfax';
        contractFairfax.Status__c = 'Pendente';
        contractFairfax.StartDate__c = Date.today();
        contractFairfax.EndDate__c = Date.today() + 1;
        contractFairfax.RecordTypeId = recordTypeIdContract;
        contractFairfax.Account__c = acc.Id;

        contractLst.add(contractFairfax);

        Contract2__c contractFairfax2 = new Contract2__c();
        contractFairfax2.Name = TestDataFactory.generateRandomStringNumber(10);
        contractFairfax2.BidNumber__c = '1004600000159';
        contractFairfax2.ContractNumber__c = '1004600000159';
        contractFairfax2.Company__c = 'Fairfax';
        contractFairfax2.Status__c = 'Pendente';
        contractFairfax2.StartDate__c = Date.today();
        contractFairfax2.EndDate__c = Date.today() + 1;
        contractFairfax2.RecordTypeId = recordTypeIdContract;
        contractFairfax2.Account__c = acc.Id;

        contractLst.add(contractFairfax2);

         try{
            Contract2__c contractFairfax3 = new Contract2__c();
            contractFairfax3.Name = TestDataFactory.generateRandomStringNumber(10);
            contractFairfax3.ContractNumber__c = '4';
            contractFairfax3.Company__c = 'Fairfax';
            contractFairfax3.Status__c = 'Pendente';
            contractFairfax3.StartDate__c = Date.today();
            contractFairfax3.EndDate__c = Date.today() + 1;
            contractFairfax3.RecordTypeId = recordTypeIdContract;
            contractFairfax3.Account__c = acc.Id;

            insert contractFairfax3;
            contractFairfax3.BidNumber__c = contractFairfax3.ContractNumber__c;
            update contractFairfax3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Contract2__c contractFator = new Contract2__c();
        contractFator.Name = TestDataFactory.generateRandomStringNumber(10);
        contractFator.BidNumber__c = '046692019100107750012194';
        contractFator.ContractNumber__c = '046692019100107750012194';
        contractFator.Company__c = 'Fator';
        contractFator.Status__c = 'Pendente';
        contractFator.StartDate__c = Date.today();
        contractFator.EndDate__c = Date.today() + 1;
        contractFator.RecordTypeId = recordTypeIdContract;
        contractFator.Account__c = acc.Id;

        contractLst.add(contractFator);

        Contract2__c contractFator2 = new Contract2__c();
        contractFator2.Name = TestDataFactory.generateRandomStringNumber(10);
        contractFator2.BidNumber__c = '1007800000439';
        contractFator2.ContractNumber__c = '1007800000439';
        contractFator2.Company__c = 'Fator';
        contractFator2.Status__c = 'Pendente';
        contractFator2.StartDate__c = Date.today();
        contractFator2.EndDate__c = Date.today() + 1;
        contractFator2.RecordTypeId = recordTypeIdContract;
        contractFator2.Account__c = acc.Id;

        contractLst.add(contractFator2);

         try{
            Contract2__c contractFator3 = new Contract2__c();
            contractFator3.Name = TestDataFactory.generateRandomStringNumber(10);
            contractFator3.ContractNumber__c = '4';
            contractFator3.Company__c = 'Fator';
            contractFator3.Status__c = 'Pendente';
            contractFator3.StartDate__c = Date.today();
            contractFator3.EndDate__c = Date.today() + 1;
            contractFator3.RecordTypeId = recordTypeIdContract;
            contractFator3.Account__c = acc.Id;

            insert contractFator3;
            contractFator3.BidNumber__c = contractFator3.ContractNumber__c;
            update contractFator3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Contract2__c contractGenerali = new Contract2__c();
        contractGenerali.Name = TestDataFactory.generateRandomStringNumber(10);
        contractGenerali.BidNumber__c = '53311132807';
        contractGenerali.ContractNumber__c = '53311132807';
        contractGenerali.Company__c = 'Generali Seguros';
        contractGenerali.Status__c = 'Pendente';
        contractGenerali.StartDate__c = Date.today();
        contractGenerali.EndDate__c = Date.today() + 1;
        contractGenerali.RecordTypeId = recordTypeIdContract;
        contractGenerali.Account__c = acc.Id;

        contractLst.add(contractGenerali);

        Contract2__c contractGenerali2 = new Contract2__c();
        contractGenerali2.Name = TestDataFactory.generateRandomStringNumber(10);
        contractGenerali2.BidNumber__c = '5331107';
        contractGenerali2.ContractNumber__c = '5331107';
        contractGenerali2.Company__c = 'Generali Seguros';
        contractGenerali2.Status__c = 'Pendente';
        contractGenerali2.StartDate__c = Date.today();
        contractGenerali2.EndDate__c = Date.today() + 1;
        contractGenerali2.RecordTypeId = recordTypeIdContract;
        contractGenerali2.Account__c = acc.Id;

        contractLst.add(contractGenerali2);

         try{
            Contract2__c contractGenerali3 = new Contract2__c();
            contractGenerali3.Name = TestDataFactory.generateRandomStringNumber(10);
            contractGenerali3.ContractNumber__c = '4';
            contractGenerali3.Company__c = 'Generali Seguros';
            contractGenerali3.Status__c = 'Pendente';
            contractGenerali3.StartDate__c = Date.today();
            contractGenerali3.EndDate__c = Date.today() + 1;
            contractGenerali3.RecordTypeId = recordTypeIdContract;
            contractGenerali3.Account__c = acc.Id;

            insert contractGenerali3;
            contractGenerali3.BidNumber__c = contractGenerali3.ContractNumber__c;
            update contractGenerali3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Contract2__c contractHDI = new Contract2__c();
        contractHDI.Name = TestDataFactory.generateRandomStringNumber(10);
        contractHDI.BidNumber__c = '01.030.131.012962.000000 - 1';
        contractHDI.ContractNumber__c = '01.030.131.012962.000000 - 1';
        contractHDI.Company__c = 'HDI Seguros';
        contractHDI.Status__c = 'Pendente';
        contractHDI.StartDate__c = Date.today();
        contractHDI.EndDate__c = Date.today() + 1;
        contractHDI.RecordTypeId = recordTypeIdContract;
        contractHDI.Account__c = acc.Id;

        contractLst.add(contractHDI);

        Contract2__c contractHDI2 = new Contract2__c();
        contractHDI2.Name = TestDataFactory.generateRandomStringNumber(10);
        contractHDI2.BidNumber__c = '12362';
        contractHDI2.ContractNumber__c = '12362';
        contractHDI2.Company__c = 'HDI Seguros';
        contractHDI2.Status__c = 'Pendente';
        contractHDI2.StartDate__c = Date.today();
        contractHDI2.EndDate__c = Date.today() + 1;
        contractHDI2.RecordTypeId = recordTypeIdContract;
        contractHDI2.Account__c = acc.Id;

        contractLst.add(contractHDI2);

         try{
            Contract2__c contractHDI3 = new Contract2__c();
            contractHDI3.Name = TestDataFactory.generateRandomStringNumber(10);
            contractHDI3.ContractNumber__c = '4';
            contractHDI3.Company__c = 'HDI Seguros';
            contractHDI3.Status__c = 'Pendente';
            contractHDI3.StartDate__c = Date.today();
            contractHDI3.EndDate__c = Date.today() + 1;
            contractHDI3.RecordTypeId = recordTypeIdContract;
            contractHDI3.Account__c = acc.Id;

            insert contractHDI3;
            contractHDI3.BidNumber__c = contractHDI3.ContractNumber__c;
            update contractHDI3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Contract2__c contractKovrSeguradora = new Contract2__c();
        contractKovrSeguradora.Name = TestDataFactory.generateRandomStringNumber(10);
        contractKovrSeguradora.BidNumber__c = '011.1004600005115';
        contractKovrSeguradora.ContractNumber__c = '011.1004600005115';
        contractKovrSeguradora.Company__c = 'Kovr Seguradora S/A';
        contractKovrSeguradora.Status__c = 'Pendente';
        contractKovrSeguradora.StartDate__c = Date.today();
        contractKovrSeguradora.EndDate__c = Date.today() + 1;
        contractKovrSeguradora.RecordTypeId = recordTypeIdContract;
        contractKovrSeguradora.Account__c = acc.Id;

        contractLst.add(contractKovrSeguradora);

        Contract2__c contractKovrSeguradora2 = new Contract2__c();
        contractKovrSeguradora2.Name = TestDataFactory.generateRandomStringNumber(10);
        contractKovrSeguradora2.BidNumber__c = '1005600005115';
        contractKovrSeguradora2.ContractNumber__c = '1005600005115';
        contractKovrSeguradora2.Company__c = 'Kovr Seguradora S/A';
        contractKovrSeguradora2.Status__c = 'Pendente';
        contractKovrSeguradora2.StartDate__c = Date.today();
        contractKovrSeguradora2.EndDate__c = Date.today() + 1;
        contractKovrSeguradora2.RecordTypeId = recordTypeIdContract;
        contractKovrSeguradora2.Account__c = acc.Id;

        contractLst.add(contractKovrSeguradora2);

        Contract2__c contractKovrSeguradora3 = new Contract2__c();
        contractKovrSeguradora3.Name = TestDataFactory.generateRandomStringNumber(10);
        contractKovrSeguradora3.BidNumber__c = '1005600005112315';
        contractKovrSeguradora3.ContractNumber__c = '1005600005112315';
        contractKovrSeguradora3.Company__c = 'Kovr Seguradora S/A';
        contractKovrSeguradora3.Status__c = 'Pendente';
        contractKovrSeguradora3.StartDate__c = Date.today();
        contractKovrSeguradora3.EndDate__c = Date.today() + 1;
        contractKovrSeguradora3.RecordTypeId = recordTypeIdContract;
        contractKovrSeguradora3.Account__c = acc.Id;

        contractLst.add(contractKovrSeguradora3);

         try{
            Contract2__c contractKovrSeguradora4 = new Contract2__c();
            contractKovrSeguradora4.Name = TestDataFactory.generateRandomStringNumber(10);
            contractKovrSeguradora4.ContractNumber__c = '4';
            contractKovrSeguradora4.Company__c = 'Kovr Seguradora S/A';
            contractKovrSeguradora4.Status__c = 'Pendente';
            contractKovrSeguradora4.StartDate__c = Date.today();
            contractKovrSeguradora4.EndDate__c = Date.today() + 1;
            contractKovrSeguradora4.RecordTypeId = recordTypeIdContract;
            contractKovrSeguradora4.Account__c = acc.Id;

            insert contractKovrSeguradora4;
            contractKovrSeguradora4.BidNumber__c = contractKovrSeguradora4.ContractNumber__c;
            update contractKovrSeguradora4;
            insert contractLst;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        for(Contract2__c ctr : contractLst){
            if(ctr.ContractNumber__c == null || ctr.ContractNumber__c == ''){
                ctr.ContractNumber__c = ctr.BidNumber__c;
                ctr.Status__c = 'Ativo';
                ctrUpdateList.add(ctr);
                System.debug('tamanho da lista de update' + ctrUpdateList.size());
            }
        }
        System.debug('tamanho da lista de update fora do IF' + ctrUpdateList.size());
        update ctrUpdateList;
        Test.stopTest();
    }

    @isTest
    public static void processarContractNumber5Test(){
        List<Contract2__c> contractLst = new List<Contract2__c>();
        List<Contract2__c> ctrUpdateList = new List<Contract2__c>();

        Test.startTest();
        Account acc = AccountDataFactory.insertPersonAccount();

        Contract2__c contractItau = new Contract2__c();
        contractItau.Name = TestDataFactory.generateRandomStringNumber(10);
        contractItau.BidNumber__c = '33.31.17811849.0';
        contractItau.ContractNumber__c = '33.31.17811849.0';
        contractItau.Company__c = 'Itau Seguros';
        contractItau.Status__c = 'Pendente';
        contractItau.StartDate__c = Date.today();
        contractItau.EndDate__c = Date.today() + 1;
        contractItau.RecordTypeId = recordTypeIdContract;
        contractItau.Account__c = acc.Id;

        contractLst.add(contractItau);

        Contract2__c contractItau2 = new Contract2__c();
        contractItau2.Name = TestDataFactory.generateRandomStringNumber(10);
        contractItau2.BidNumber__c = '17811840';
        contractItau2.ContractNumber__c = '17811840';
        contractItau2.Company__c = 'Itau Seguros';
        contractItau2.Status__c = 'Pendente';
        contractItau2.StartDate__c = Date.today();
        contractItau2.EndDate__c = Date.today() + 1;
        contractItau2.RecordTypeId = recordTypeIdContract;
        contractItau2.Account__c = acc.Id;

        contractLst.add(contractItau2);

         try{
            Contract2__c contractItau3 = new Contract2__c();
            contractItau3.Name = TestDataFactory.generateRandomStringNumber(10);
            contractItau3.ContractNumber__c = '4';
            contractItau3.Company__c = 'Itau Seguros';
            contractItau3.Status__c = 'Pendente';
            contractItau3.StartDate__c = Date.today();
            contractItau3.EndDate__c = Date.today() + 1;
            contractItau3.RecordTypeId = recordTypeIdContract;
            contractItau3.Account__c = acc.Id;
            insert contractItau3;
            contractItau3.BidNumber__c = contractItau3.ContractNumber__c;
            update contractItau3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Contract2__c contractLiberty = new Contract2__c();
        contractLiberty.Name = TestDataFactory.generateRandomStringNumber(10);
        contractLiberty.BidNumber__c = '67.94.003.551';
        contractLiberty.ContractNumber__c = '67.94.003.551';
        contractLiberty.Company__c = 'Liberty Seguros';
        contractLiberty.Status__c = 'Pendente';
        contractLiberty.StartDate__c = Date.today();
        contractLiberty.EndDate__c = Date.today() + 1;
        contractLiberty.RecordTypeId = recordTypeIdContract;
        contractLiberty.Account__c = acc.Id;

        contractLst.add(contractLiberty);

        Contract2__c contractLiberty2 = new Contract2__c();
        contractLiberty2.Name = TestDataFactory.generateRandomStringNumber(10);
        contractLiberty2.BidNumber__c = '6794003552';
        contractLiberty2.ContractNumber__c = '6794003552';
        contractLiberty2.Company__c = 'Liberty Seguros';
        contractLiberty2.Status__c = 'Pendente';
        contractLiberty2.StartDate__c = Date.today();
        contractLiberty2.EndDate__c = Date.today() + 1;
        contractLiberty2.RecordTypeId = recordTypeIdContract;
        contractLiberty2.Account__c = acc.Id;

        contractLst.add(contractLiberty2);

         try{
            Contract2__c contractLiberty3 = new Contract2__c();
            contractLiberty3.Name = TestDataFactory.generateRandomStringNumber(10);
            contractLiberty3.ContractNumber__c = '4';
            contractLiberty3.Company__c = 'Liberty Seguros';
            contractLiberty3.Status__c = 'Pendente';
            contractLiberty3.StartDate__c = Date.today();
            contractLiberty3.EndDate__c = Date.today() + 1;
            contractLiberty3.RecordTypeId = recordTypeIdContract;
            contractLiberty3.Account__c = acc.Id;
            insert contractLiberty3;
            contractLiberty3.BidNumber__c = contractLiberty3.ContractNumber__c;
            update contractLiberty3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Contract2__c contractMapfre = new Contract2__c();
        contractMapfre.Name = TestDataFactory.generateRandomStringNumber(10);
        contractMapfre.BidNumber__c = '6924/0002223/62';
        contractMapfre.ContractNumber__c = '6924/0002223/62';
        contractMapfre.Company__c = 'Mapfre Vida';
        contractMapfre.Status__c = 'Pendente';
        contractMapfre.StartDate__c = Date.today();
        contractMapfre.EndDate__c = Date.today() + 1;
        contractMapfre.RecordTypeId = recordTypeIdContract;
        contractMapfre.Account__c = acc.Id;

        contractLst.add(contractMapfre);

        Contract2__c contractMapfre2 = new Contract2__c();
        contractMapfre2.Name = TestDataFactory.generateRandomStringNumber(10);
        contractMapfre2.BidNumber__c = '6924000222361';
        contractMapfre2.ContractNumber__c = '6924000222361';
        contractMapfre2.Company__c = 'Mapfre Vida';
        contractMapfre2.Status__c = 'Pendente';
        contractMapfre2.StartDate__c = Date.today();
        contractMapfre2.EndDate__c = Date.today() + 1;
        contractMapfre2.RecordTypeId = recordTypeIdContract;
        contractMapfre2.Account__c = acc.Id;

        contractLst.add(contractMapfre2);

         try{
            Contract2__c contractMapfre3 = new Contract2__c();
            contractMapfre3.Name = TestDataFactory.generateRandomStringNumber(10);
            contractMapfre3.ContractNumber__c = '4';
            contractMapfre3.Company__c = 'Mapfre Vida';
            contractMapfre3.Status__c = 'Pendente';
            contractMapfre3.StartDate__c = Date.today();
            contractMapfre3.EndDate__c = Date.today() + 1;
            contractMapfre3.RecordTypeId = recordTypeIdContract;
            contractMapfre3.Account__c = acc.Id;

            insert contractMapfre3;
            contractMapfre3.BidNumber__c = contractMapfre3.ContractNumber__c;
            update contractMapfre3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Contract2__c contractMetlife = new Contract2__c();
        contractMetlife.Name = TestDataFactory.generateRandomStringNumber(10);
        contractMetlife.BidNumber__c = '69308001';
        contractMetlife.ContractNumber__c = '69308001';
        contractMetlife.Company__c = 'MetLife';
        contractMetlife.Status__c = 'Pendente';
        contractMetlife.StartDate__c = Date.today();
        contractMetlife.EndDate__c = Date.today() + 1;
        contractMetlife.RecordTypeId = recordTypeIdContract;
        contractMetlife.Account__c = acc.Id;

        contractLst.add(contractMetlife);

        Contract2__c contractMetlife2 = new Contract2__c();
        contractMetlife2.Name = TestDataFactory.generateRandomStringNumber(10);
        contractMetlife2.BidNumber__c = '69309';
        contractMetlife2.ContractNumber__c = '69309';
        contractMetlife2.Company__c = 'MetLife';
        contractMetlife2.Status__c = 'Pendente';
        contractMetlife2.StartDate__c = Date.today();
        contractMetlife2.EndDate__c = Date.today() + 1;
        contractMetlife2.RecordTypeId = recordTypeIdContract;
        contractMetlife2.Account__c = acc.Id;

        contractLst.add(contractMetlife2);

         try{
            Contract2__c contractMetlife3 = new Contract2__c();
            contractMetlife3.Name = TestDataFactory.generateRandomStringNumber(10);
            contractMetlife3.ContractNumber__c = '4';
            contractMetlife3.Company__c = 'MetLife';
            contractMetlife3.Status__c = 'Pendente';
            contractMetlife3.StartDate__c = Date.today();
            contractMetlife3.EndDate__c = Date.today() + 1;
            contractMetlife3.RecordTypeId = recordTypeIdContract;
            contractMetlife3.Account__c = acc.Id;

            insert contractMetlife3;
            contractMetlife3.BidNumber__c = contractMetlife3.ContractNumber__c;
            update contractMetlife3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Contract2__c contractMitsui = new Contract2__c();
        contractMitsui.Name = TestDataFactory.generateRandomStringNumber(10);
        contractMitsui.BidNumber__c = '01180072655';
        contractMitsui.ContractNumber__c = '01180072655';
        contractMitsui.Company__c = 'Mitsui Sumitomo Seguros';
        contractMitsui.Status__c = 'Pendente';
        contractMitsui.StartDate__c = Date.today();
        contractMitsui.EndDate__c = Date.today() + 1;
        contractMitsui.RecordTypeId = recordTypeIdContract;
        contractMitsui.Account__c = acc.Id;

        contractLst.add(contractMitsui);

        Contract2__c contractMitsui2 = new Contract2__c();
        contractMitsui2.Name = TestDataFactory.generateRandomStringNumber(10);
        contractMitsui2.BidNumber__c = '2180072655';
        contractMitsui2.ContractNumber__c = '2180072655';
        contractMitsui2.Company__c = 'Mitsui Sumitomo Seguros';
        contractMitsui2.Status__c = 'Pendente';
        contractMitsui2.StartDate__c = Date.today();
        contractMitsui2.EndDate__c = Date.today() + 1;
        contractMitsui2.RecordTypeId = recordTypeIdContract;
        contractMitsui2.Account__c = acc.Id;

        contractLst.add(contractMitsui2);

         try{
            Contract2__c contractMitsui3 = new Contract2__c();
            contractMitsui3.Name = TestDataFactory.generateRandomStringNumber(10);
            contractMitsui3.ContractNumber__c = '4';
            contractMitsui3.Company__c = 'Mitsui Sumitomo Seguros';
            contractMitsui3.Status__c = 'Pendente';
            contractMitsui3.StartDate__c = Date.today();
            contractMitsui3.EndDate__c = Date.today() + 1;
            contractMitsui3.RecordTypeId = recordTypeIdContract;
            contractMitsui3.Account__c = acc.Id;

            insert contractMitsui3;
            contractMitsui3.BidNumber__c = contractMitsui3.ContractNumber__c;
            update contractMitsui3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        insert contractLst;
        for(Contract2__c ctr : contractLst){
            if(ctr.ContractNumber__c == null || ctr.ContractNumber__c == ''){
                ctr.ContractNumber__c = ctr.BidNumber__c;
                ctr.Status__c = 'Ativo';
                ctrUpdateList.add(ctr);
                System.debug('tamanho da lista de update' + ctrUpdateList.size());
            }
        }
        System.debug('tamanho da lista de update fora do IF' + ctrUpdateList.size());
        update ctrUpdateList;
        Test.stopTest();
    }

    @isTest
    public static void processarContractNumber6Test(){
        List<Contract2__c> contractLst = new List<Contract2__c>();
        List<Contract2__c> ctrUpdateList = new List<Contract2__c>();

        Test.startTest();
        Account acc = AccountDataFactory.insertPersonAccount();
        Contract2__c contractMagSeguros = new Contract2__c();
        contractMagSeguros.Name = TestDataFactory.generateRandomStringNumber(10);
        contractMagSeguros.BidNumber__c = '2180072655';
        contractMagSeguros.ContractNumber__c = '2180072655';
        contractMagSeguros.Company__c = 'MAG Seguros';
        contractMagSeguros.Status__c = 'Pendente';
        contractMagSeguros.StartDate__c = Date.today();
        contractMagSeguros.EndDate__c = Date.today() + 1;
        contractMagSeguros.RecordTypeId = recordTypeIdContract;
        contractMagSeguros.Account__c = acc.Id;

        contractLst.add(contractMagSeguros);

        Contract2__c contractMagSeguros2 = new Contract2__c();
        contractMagSeguros2.Name = TestDataFactory.generateRandomStringNumber(10);
        contractMagSeguros2.BidNumber__c = '52742';
        contractMagSeguros2.ContractNumber__c = '52742';
        contractMagSeguros2.Company__c = 'MAG Seguros';
        contractMagSeguros2.Status__c = 'Pendente';
        contractMagSeguros2.StartDate__c = Date.today();
        contractMagSeguros2.EndDate__c = Date.today() + 1;
        contractMagSeguros2.RecordTypeId = recordTypeIdContract;
        contractMagSeguros2.Account__c = acc.Id;

        contractLst.add(contractMagSeguros2);

         try{
            Contract2__c contractMagSeguros3 = new Contract2__c();
            contractMagSeguros3.Name = TestDataFactory.generateRandomStringNumber(10);
            contractMagSeguros3.ContractNumber__c = '4';
            contractMagSeguros3.Company__c = 'MAG Seguros';
            contractMagSeguros3.Status__c = 'Pendente';
            contractMagSeguros3.StartDate__c = Date.today();
            contractMagSeguros3.EndDate__c = Date.today() + 1;
            contractMagSeguros3.RecordTypeId = recordTypeIdContract;
            contractMagSeguros3.Account__c = acc.Id;

            insert contractMagSeguros3;
            contractMagSeguros3.BidNumber__c = contractMAGSeguros3.ContractNumber__c;
            update contractMagSeguros3;
        } catch (Exception e){
            // System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Contract2__c contractNobre = new Contract2__c();
        contractNobre.Name = TestDataFactory.generateRandomStringNumber(10);
        contractNobre.BidNumber__c = '2001/96/00000036/0 ';
        contractNobre.ContractNumber__c = '2001/96/00000036/0 ';
        contractNobre.Company__c = 'Nobre';
        contractNobre.Status__c = 'Pendente';
        contractNobre.StartDate__c = Date.today();
        contractNobre.EndDate__c = Date.today() + 1;
        contractNobre.RecordTypeId = recordTypeIdContract;
        contractNobre.Account__c = acc.Id;

        contractLst.add(contractNobre);

        Contract2__c contractNobre2 = new Contract2__c();
        contractNobre2.Name = TestDataFactory.generateRandomStringNumber(10);
        contractNobre2.BidNumber__c = '38';
        contractNobre2.ContractNumber__c = '38';
        contractNobre2.Company__c = 'Nobre';
        contractNobre2.Status__c = 'Pendente';
        contractNobre2.StartDate__c = Date.today();
        contractNobre2.EndDate__c = Date.today() + 1;
        contractNobre2.RecordTypeId = recordTypeIdContract;
        contractNobre2.Account__c = acc.Id;

        contractLst.add(contractNobre2);

         try{
            Contract2__c contractNobre3 = new Contract2__c();
            contractNobre3.Name = TestDataFactory.generateRandomStringNumber(10);
            contractNobre3.ContractNumber__c = '4';
            contractNobre3.Company__c = 'Nobre';
            contractNobre3.Status__c = 'Pendente';
            contractNobre3.StartDate__c = Date.today();
            contractNobre3.EndDate__c = Date.today() + 1;
            contractNobre3.RecordTypeId = recordTypeIdContract;
            contractNobre3.Account__c = acc.Id;

            insert contractNobre3;
            contractNobre3.BidNumber__c = contractNobre3.ContractNumber__c;
            update contractNobre3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Contract2__c contractPorto = new Contract2__c();
        contractPorto.Name = TestDataFactory.generateRandomStringNumber(10);
        contractPorto.BidNumber__c = '0118.11.54.779-9';
        contractPorto.ContractNumber__c = '0118.11.54.779-9';
        contractPorto.Company__c = 'Porto Seguro';
        contractPorto.Status__c = 'Pendente';
        contractPorto.StartDate__c = Date.today();
        contractPorto.EndDate__c = Date.today() + 1;
        contractPorto.RecordTypeId = recordTypeIdContract;
        contractPorto.Account__c = acc.Id;

        contractLst.add(contractPorto);

        Contract2__c contractPorto2 = new Contract2__c();
        contractPorto2.Name = TestDataFactory.generateRandomStringNumber(10);
        contractPorto2.BidNumber__c = '4000068';
        contractPorto2.ContractNumber__c = '4000068';
        contractPorto2.Company__c = 'Porto Seguro';
        contractPorto2.Status__c = 'Pendente';
        contractPorto2.StartDate__c = Date.today();
        contractPorto2.EndDate__c = Date.today() + 1;
        contractPorto2.RecordTypeId = recordTypeIdContract;
        contractPorto2.Account__c = acc.Id;

        contractLst.add(contractPorto2);

         try{
            Contract2__c contractPorto3 = new Contract2__c();
            contractPorto3.Name = TestDataFactory.generateRandomStringNumber(10);
            contractPorto3.BidNumber__c = '469';
            contractPorto3.ContractNumber__c = '469';
            contractPorto3.Company__c = 'Porto Seguro';
            contractPorto3.Status__c = 'Pendente';
            contractPorto3.StartDate__c = Date.today();
            contractPorto3.EndDate__c = Date.today() + 1;
            contractPorto3.RecordTypeId = recordTypeIdContract;
            contractPorto3.Account__c = acc.Id;

            insert contractPorto3;
            contractPorto3.BidNumber__c = contractPorto3.ContractNumber__c;
            update contractPorto3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        insert contractLst;
        for(Contract2__c ctr : contractLst){
            if(ctr.ContractNumber__c == null || ctr.ContractNumber__c == ''){
                ctr.ContractNumber__c = ctr.BidNumber__c;
                ctr.Status__c = 'Ativo';
                ctrUpdateList.add(ctr);
                System.debug('tamanho da lista de update' + ctrUpdateList.size());
            }
        }
        System.debug('tamanho da lista de update fora do IF' + ctrUpdateList.size());
        update ctrUpdateList;
        Test.stopTest();
    }

    @isTest
    public static void processarContractNumber7Test(){
        List<Contract2__c> contractLst = new List<Contract2__c>();
        List<Contract2__c> ctrUpdateList = new List<Contract2__c>();

        Test.startTest();
        Account acc = AccountDataFactory.insertPersonAccount();

        Contract2__c contractPottencial = new Contract2__c();
        contractPottencial.Name = TestDataFactory.generateRandomStringNumber(10);
        contractPottencial.BidNumber__c = '0306920189907750240991000';
        contractPottencial.ContractNumber__c = '0306920189907750240991000';
        contractPottencial.Company__c = 'Pottencial Seguradora';
        contractPottencial.Status__c = 'Pendente';
        contractPottencial.StartDate__c = Date.today();
        contractPottencial.EndDate__c = Date.today() + 1;
        contractPottencial.RecordTypeId = recordTypeIdContract;
        contractPottencial.Account__c = acc.Id;

        contractLst.add(contractPottencial);

        Contract2__c contractPottencial2 = new Contract2__c();
        contractPottencial2.Name = TestDataFactory.generateRandomStringNumber(10);
        contractPottencial2.BidNumber__c = '0240992';
        contractPottencial2.ContractNumber__c = '0240992';
        contractPottencial2.Company__c = 'Pottencial Seguradora';
        contractPottencial2.Status__c = 'Pendente';
        contractPottencial2.StartDate__c = Date.today();
        contractPottencial2.EndDate__c = Date.today() + 1;
        contractPottencial2.RecordTypeId = recordTypeIdContract;
        contractPottencial2.Account__c = acc.Id;

        contractLst.add(contractPottencial2);

        Contract2__c contractPottencial3 = new Contract2__c();
        contractPottencial3.Name = TestDataFactory.generateRandomStringNumber(10);
        contractPottencial3.BidNumber__c = '0306920189907760340991000';
        contractPottencial3.ContractNumber__c = '0306920189907760340991000';
        contractPottencial3.Company__c = 'Pottencial Seguradora';
        contractPottencial3.Status__c = 'Pendente';
        contractPottencial3.StartDate__c = Date.today();
        contractPottencial3.EndDate__c = Date.today() + 1;
        contractPottencial3.RecordTypeId = recordTypeIdContract;
        contractPottencial3.Account__c = acc.Id;

        contractLst.add(contractPottencial3);

        Contract2__c contractPottencial4 = new Contract2__c();
        contractPottencial4.Name = TestDataFactory.generateRandomStringNumber(10);
        contractPottencial4.BidNumber__c = '0306920189907460699191110';
        contractPottencial4.ContractNumber__c = '0306920189907460699191110';
        contractPottencial4.Company__c = 'Pottencial Seguradora';
        contractPottencial4.Status__c = 'Pendente';
        contractPottencial4.StartDate__c = Date.today();
        contractPottencial4.EndDate__c = Date.today() + 1;
        contractPottencial4.RecordTypeId = recordTypeIdContract;
        contractPottencial4.Account__c = acc.Id;

        contractLst.add(contractPottencial4);

        Contract2__c contractPottencial5 = new Contract2__c();
        contractPottencial5.Name = TestDataFactory.generateRandomStringNumber(10);
        contractPottencial5.BidNumber__c = '03069-20189907460640191000';
        contractPottencial5.ContractNumber__c = '03069-20189907460640191000';
        contractPottencial5.Company__c = 'Pottencial Seguradora';
        contractPottencial5.Status__c = 'Pendente';
        contractPottencial5.StartDate__c = Date.today();
        contractPottencial5.EndDate__c = Date.today() + 1;
        contractPottencial5.RecordTypeId = recordTypeIdContract;
        contractPottencial5.Account__c = acc.Id;

        contractLst.add(contractPottencial5);

        Contract2__c contractPottencial7 = new Contract2__c();
        contractPottencial7.Name = TestDataFactory.generateRandomStringNumber(10);
        contractPottencial7.BidNumber__c = '0306920219901670004141000';
        contractPottencial7.ContractNumber__c = '0306920219901670004141000';
        contractPottencial7.Company__c = 'Pottencial Seguradora';
        contractPottencial7.Status__c = 'Pendente';
        contractPottencial7.StartDate__c = Date.today();
        contractPottencial7.EndDate__c = Date.today() + 1;
        contractPottencial7.RecordTypeId = recordTypeIdContract;
        contractPottencial7.Account__c = acc.Id;

        contractLst.add(contractPottencial7);

         try{
            Contract2__c contractPottencial6 = new Contract2__c();
            contractPottencial6.Name = TestDataFactory.generateRandomStringNumber(10);
            contractPottencial6.ContractNumber__c = '5';
            contractPottencial6.Company__c = 'Pottencial Seguradora';
            contractPottencial6.Status__c = 'Pendente';
            contractPottencial6.StartDate__c = Date.today();
            contractPottencial6.EndDate__c = Date.today() + 1;
            contractPottencial6.RecordTypeId = recordTypeIdContract;
            contractPottencial6.Account__c = acc.Id;

            insert contractPottencial6;
            contractPottencial6.BidNumber__c = contractPottencial6.ContractNumber__c;
            update contractPottencial6;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        insert contractLst;
        for(Contract2__c ctr : contractLst){
            if(ctr.ContractNumber__c == null || ctr.ContractNumber__c == ''){
                ctr.ContractNumber__c = ctr.BidNumber__c;
                ctr.Status__c = 'Ativo';
                ctrUpdateList.add(ctr);
                System.debug('tamanho da lista de update' + ctrUpdateList.size());
            }
        }
        System.debug('tamanho da lista de update fora do IF' + ctrUpdateList.size());
        update ctrUpdateList;

        Test.stopTest();
    }

    @isTest
    public static void processarContractNumber8Test(){
        List<Contract2__c> contractLst = new List<Contract2__c>();
        List<Contract2__c> ctrUpdateList = new List<Contract2__c>();

        Test.startTest();
        Account acc = AccountDataFactory.insertPersonAccount();

        Contract2__c contractSulAmerica = new Contract2__c();
        contractSulAmerica.Name = TestDataFactory.generateRandomStringNumber(10);
        contractSulAmerica.BidNumber__c = '110310213215';
        contractSulAmerica.ContractNumber__c = '110310213215';
        contractSulAmerica.Company__c = 'SulAmérica';
        contractSulAmerica.Status__c = 'Pendente';
        contractSulAmerica.StartDate__c = Date.today();
        contractSulAmerica.EndDate__c = Date.today() + 1;
        contractSulAmerica.RecordTypeId = recordTypeIdContract;
        contractSulAmerica.Account__c = acc.Id;

        contractLst.add(contractSulAmerica);

        Contract2__c contractSulAmerica2 = new Contract2__c();
        contractSulAmerica2.Name = TestDataFactory.generateRandomStringNumber(10);
        contractSulAmerica2.BidNumber__c = '3792399';
        contractSulAmerica2.ContractNumber__c = '3792399';
        contractSulAmerica2.Company__c = 'SulAmérica';
        contractSulAmerica2.Status__c = 'Pendente';
        contractSulAmerica2.StartDate__c = Date.today();
        contractSulAmerica2.EndDate__c = Date.today() + 1;
        contractSulAmerica2.RecordTypeId = recordTypeIdContract;
        contractSulAmerica2.Account__c = acc.Id;

        contractLst.add(contractSulAmerica2);

         try{
            Contract2__c contractSulAmerica3 = new Contract2__c();
            contractSulAmerica3.Name = TestDataFactory.generateRandomStringNumber(10);
            contractSulAmerica3.ContractNumber__c = '4';
            contractSulAmerica3.Company__c = 'SulAmérica';
            contractSulAmerica3.Status__c = 'Pendente';
            contractSulAmerica3.StartDate__c = Date.today();
            contractSulAmerica3.EndDate__c = Date.today() + 1;
            contractSulAmerica3.RecordTypeId = recordTypeIdContract;
            contractSulAmerica3.Account__c = acc.Id;

            insert contractSulAmerica3;
            contractSulAmerica3.BidNumber__c = contractSulAmerica3.ContractNumber__c;
            update contractSulAmerica3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Contract2__c contractTokio = new Contract2__c();
        contractTokio.Name = TestDataFactory.generateRandomStringNumber(10);
        contractTokio.BidNumber__c = '61902017890407750008937';
        contractTokio.ContractNumber__c = '61902017890407750008937';
        contractTokio.Company__c = 'Tokio Marine';
        contractTokio.Status__c = 'Pendente';
        contractTokio.StartDate__c = Date.today();
        contractTokio.EndDate__c = Date.today() + 1;
        contractTokio.RecordTypeId = recordTypeIdContract;
        contractTokio.Account__c = acc.Id;

        contractLst.add(contractTokio);

        Contract2__c contractTokio2 = new Contract2__c();
        contractTokio2.Name = TestDataFactory.generateRandomStringNumber(10);
        contractTokio2.BidNumber__c = '000 0000023071';
        contractTokio2.ContractNumber__c = '000 0000023071';
        contractTokio2.Company__c = 'Tokio Marine';
        contractTokio2.Status__c = 'Pendente';
        contractTokio2.StartDate__c = Date.today();
        contractTokio2.EndDate__c = Date.today() + 1;
        contractTokio2.RecordTypeId = recordTypeIdContract;
        contractTokio2.Account__c = acc.Id;

        contractLst.add(contractTokio2);

        Contract2__c contractTokio3 = new Contract2__c();
        contractTokio3.Name = TestDataFactory.generateRandomStringNumber(10);
        contractTokio3.BidNumber__c = '02271';
        contractTokio3.ContractNumber__c = '02271';
        contractTokio3.Company__c = 'Tokio Marine';
        contractTokio3.Status__c = 'Pendente';
        contractTokio3.StartDate__c = Date.today();
        contractTokio3.EndDate__c = Date.today() + 1;
        contractTokio3.RecordTypeId = recordTypeIdContract;
        contractTokio3.Account__c = acc.Id;

        contractLst.add(contractTokio3);

         try{
            Contract2__c contractTokio4 = new Contract2__c();
            contractTokio4.Name = TestDataFactory.generateRandomStringNumber(10);
            contractTokio4.ContractNumber__c = '4';
            contractTokio4.Company__c = 'Tokio Marine';
            contractTokio4.Status__c = 'Pendente';
            contractTokio4.StartDate__c = Date.today();
            contractTokio4.EndDate__c = Date.today() + 1;
            contractTokio4.RecordTypeId = recordTypeIdContract;
            contractTokio4.Account__c = acc.Id;

            insert contractTokio4;
            contractTokio4.BidNumber__c = contractTokio4.BidNumber__c;
            update contractTokio4;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Contract2__c contractXI = new Contract2__c();
        contractXI.Name = TestDataFactory.generateRandomStringNumber(10);
        contractXI.BidNumber__c = '01961000393';
        contractXI.ContractNumber__c = '01961000393';
        contractXI.Company__c = 'XI Seguros';
        contractXI.Status__c = 'Pendente';
        contractXI.StartDate__c = Date.today();
        contractXI.EndDate__c = Date.today() + 1;
        contractXI.RecordTypeId = recordTypeIdContract;
        contractXI.Account__c = acc.Id;

        contractLst.add(contractXI);

        Contract2__c contractXI2 = new Contract2__c();
        contractXI2.Name = TestDataFactory.generateRandomStringNumber(10);
        contractXI2.BidNumber__c = '2961000393';
        contractXI2.ContractNumber__c = '2961000393';
        contractXI2.Company__c = 'XI Seguros';
        contractXI2.Status__c = 'Pendente';
        contractXI2.StartDate__c = Date.today();
        contractXI2.EndDate__c = Date.today() + 1;
        contractXI2.RecordTypeId = recordTypeIdContract;
        contractXI2.Account__c = acc.Id;

        contractLst.add(contractXI2);

         try{
            Contract2__c contractXI3 = new Contract2__c();
            contractXI3.Name = TestDataFactory.generateRandomStringNumber(10);
            contractXI3.ContractNumber__c = '4';
            contractXI3.Company__c = 'XI Seguros';
            contractXI3.Status__c = 'Pendente';
            contractXI3.StartDate__c = Date.today();
            contractXI3.EndDate__c = Date.today() + 1;
            contractXI3.RecordTypeId = recordTypeIdContract;
            contractXI3.Account__c = acc.Id;

            insert contractXI3;
            contractXI3.BidNumber__c = contractXI3.ContractNumber__c;
            update contractXI3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Contract2__c contractZurich = new Contract2__c();
        contractZurich.Name = TestDataFactory.generateRandomStringNumber(10);
        contractZurich.BidNumber__c = '054952020005407460000121';
        contractZurich.ContractNumber__c = '054952020005407460000121';
        contractZurich.Company__c = 'Zurich';
        contractZurich.Status__c = 'Pendente';
        contractZurich.StartDate__c = Date.today();
        contractZurich.EndDate__c = Date.today() + 1;
        contractZurich.RecordTypeId = recordTypeIdContract;
        contractZurich.Account__c = acc.Id;

        contractLst.add(contractZurich);

        Contract2__c contractZurich2 = new Contract2__c();
        contractZurich2.Name = TestDataFactory.generateRandomStringNumber(10);
        contractZurich2.BidNumber__c = '12345';
        contractZurich2.ContractNumber__c = '12345';
        contractZurich2.Company__c = 'Zurich';
        contractZurich2.Status__c = 'Pendente';
        contractZurich2.StartDate__c = Date.today();
        contractZurich2.EndDate__c = Date.today() + 1;
        contractZurich2.RecordTypeId = recordTypeIdContract;
        contractZurich2.Account__c = acc.Id;

        contractLst.add(contractZurich2);

         try{
            Contract2__c contractZurich3 = new Contract2__c();
            contractZurich3.Name = TestDataFactory.generateRandomStringNumber(10);
            contractZurich3.ContractNumber__c = '4';
            contractZurich3.Company__c = 'Zurich';
            contractZurich3.Status__c = 'Pendente';
            contractZurich3.StartDate__c = Date.today();
            contractZurich3.EndDate__c = Date.today() + 1;
            contractZurich3.RecordTypeId = recordTypeIdContract;
            contractZurich3.Account__c = acc.Id;

            insert contractZurich3;
            contractZurich3.BidNumber__c = contractZurich3.BidNumber__c;
            update contractZurich3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        Contract2__c contractBTG = new Contract2__c();
        contractBTG.Name = TestDataFactory.generateRandomStringNumber(10);
        contractBTG.BidNumber__c = '017412016000107750000053';
        contractBTG.ContractNumber__c = '017412016000107750000053';
        contractBTG.Company__c = 'Btg Pactual';
        contractBTG.Status__c = 'Pendente';
        contractBTG.StartDate__c = Date.today();
        contractBTG.EndDate__c = Date.today() + 1;
        contractBTG.RecordTypeId = recordTypeIdContract;
        contractBTG.Account__c = acc.Id;

        contractLst.add(contractBTG);

        Contract2__c contractBTG2 = new Contract2__c();
        contractBTG2.Name = TestDataFactory.generateRandomStringNumber(10);
        contractBTG2.BidNumber__c = '107750000054';
        contractBTG2.ContractNumber__c = '107750000054';
        contractBTG2.Company__c = 'Btg Pactual';
        contractBTG2.Status__c = 'Pendente';
        contractBTG2.StartDate__c = Date.today();
        contractBTG2.EndDate__c = Date.today() + 1;
        contractBTG2.RecordTypeId = recordTypeIdContract;
        contractBTG2.Account__c = acc.Id;

        contractLst.add(contractBTG2);

         try{
            Contract2__c contractBTG3 = new Contract2__c();
            contractBTG3.Name = TestDataFactory.generateRandomStringNumber(10);
            contractBTG3.ContractNumber__c = '4';
            contractBTG3.Company__c = 'Btg Pactual';
            contractBTG3.Status__c = 'Pendente';
            contractBTG3.StartDate__c = Date.today();
            contractBTG3.EndDate__c = Date.today() + 1;
            contractBTG3.RecordTypeId = recordTypeIdContract;
            contractBTG3.Account__c = acc.Id;

            insert contractBTG3;
            contractBTG3.BidNumber__c = contractBTG3.ContractNumber__c;
            update contractBTG3;
        } catch (Exception e){
            System.assert(e.getMessage().contains('Quantidade de números incorreta'), 'Quantidade de números incorreta');
        }

        insert contractLst;
        for(Contract2__c ctr : contractLst){
            if(ctr.ContractNumber__c == null || ctr.ContractNumber__c == ''){
                ctr.ContractNumber__c = ctr.BidNumber__c;
                ctrUpdateList.add(ctr);
            }
        }
        update ctrUpdateList;

        Contract2__c contractReturn = new Contract2__c();
        contractReturn.Name = TestDataFactory.generateRandomStringNumber(10);
        contractReturn.ContractNumber__c = '054952020005407460000321';
        contractReturn.BidNumber__c = '054952020005407460000321';
        contractReturn.Company__c = 'Zurich';
        contractReturn.Status__c = 'Pendente';
        contractReturn.StartDate__c = Date.today();
        contractReturn.EndDate__c = Date.today() + 1;
        contractReturn.RecordTypeId = recordTypeIdContract;
        contractReturn.Account__c = acc.Id;

        insert contractReturn;
        contractReturn.BidNumber__c = contractReturn.ContractNumber__c;
        update contractReturn;

        Test.stopTest();
        System.assertEquals('322441000', Corporate_ContractBO.leftZeroesTrim('00000322441000'));
        System.assertEquals('', Corporate_ContractBO.leftZeroesTrim(''));
    }
}