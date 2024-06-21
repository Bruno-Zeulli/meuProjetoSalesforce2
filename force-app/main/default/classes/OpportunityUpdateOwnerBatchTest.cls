/**
 * @description       : Atualiza Order
 * @author            : viniciusazevedo@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 11-20-2022
 * @last modified by  : viniciusazevedo@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-20-2022   viniciusazevedo@wizsolucoes.com.br   Initial Version
 **/
@isTest
public class OpportunityUpdateOwnerBatchTest {

    @isTest
    static void testOpportunityUpdateOwner(){

        // User userCommunity = [SELECT Id FROM User WHERE UserType = 'PowerPartner' LIMIT 1];
        Profile profileADM = [SELECT Id FROM Profile WHERE Name = 'Administrador'];
        Id profileCommunityId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id;
        Account acc = AccountDataFactory.insertBusinessAccount();
        acc.IsPartner = true;
        update acc;

        Contact con = ContactDataFactory.insertContact();
        con.AccountId = acc.Id;
        // con.IsPartner = true;
        update con;

        // Id roleCommunityId = [SELECT Id FROM UserRole WHERE Name LIKE '%Executivo deParceiro%' LIMIT 1].Id;
        User userCommunity = new User();

        // set the necessary user fields
        userCommunity.FirstName = 'John';
        userCommunity.LastName = 'Doe';
        userCommunity.Email = 'johndoe@email.com';
        userCommunity.Username = 'johndoe@wiz.co.enterprise';
        userCommunity.CommunityNickname = 'johndoe';
        // userCommunity.UserRoleId = roleCommunityId;
        userCommunity.ProfileId = profileCommunityId;
        userCommunity.Alias = 'johndo';
        userCommunity.TimeZoneSidKey = 'America/Los_Angeles';
        userCommunity.LocaleSidKey = 'en_US';
        userCommunity.EmailEncodingKey = 'UTF-8';
        userCommunity.LanguageLocaleKey = 'en_US';
        // userCommunity.ContactId = con.Id;

        // insert the user record
        insert userCommunity;

        User userStandard = new User();
        userStandard.LastName = 'testeadm';
        userStandard.Email = 'teste123adm@gmail.com';
        userStandard.Username = 'teste123adm@gmail.com';
        userStandard.Alias = 'testa';
        userStandard.TimeZoneSidKey = 'America/Sao_Paulo';
        userStandard.LocaleSidKey = 'pt_BR';
        userStandard.EmailEncodingKey = 'ISO-8859-1';
        userStandard.ProfileId = profileADM.Id;
        userStandard.LanguageLocaleKey = 'pt_BR';

        insert userStandard;

        Opportunity oppInsert = new Opportunity();
        oppInsert.StageName = 'Fechado e ganho';
        oppInsert.Name = 'Test opp';
        oppInsert.CloseDate = Date.today().addDays(30);
        oppInsert.Type = 'MechanicalWarranty';
        oppInsert.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Conseg').getRecordTypeId();
        oppInsert.OwnerId = userStandard.Id;
        oppInsert.Estrategia5__c = userCommunity.Id;

        insert oppInsert;

        Opportunity oppInsert2 = new Opportunity();
        oppInsert2.StageName = 'Fechado e perdido';
        oppInsert2.Name = 'Test opp';
        oppInsert2.CloseDate = Date.today().addDays(30);
        oppInsert2.Type = 'MechanicalWarranty';
        oppInsert2.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Conseg').getRecordTypeId();
        oppInsert2.OwnerId = userStandard.Id;
        oppInsert2.Estrategia5__c = userCommunity.Id;

        insert oppInsert2;


        // Inicia o processo em lote
        Test.startTest();
        OpportunityUpdateOwnerSchedule.schedule();
        OpportunityUpdateOwnerBatch batch = new OpportunityUpdateOwnerBatch();
        Database.executeBatch(batch);
        Test.stopTest();

        // Verifica se a oportunidade foi excluída
        Opportunity opp = [SELECT Id, OwnerId, Estrategia5__c FROM Opportunity WHERE Id =:oppInsert.Id];
        System.assertEquals(opp.OwnerId, opp.Estrategia5__c, 'OpportunityOwner é diferente do Estrategia5__c');
        Opportunity opp2 = [SELECT Id, OwnerId, Estrategia5__c FROM Opportunity WHERE Id =:oppInsert2.Id];
        System.assertEquals(opp2.OwnerId, opp2.Estrategia5__c, 'OpportunityOwner é diferente do Estrategia5__c');
    }
}