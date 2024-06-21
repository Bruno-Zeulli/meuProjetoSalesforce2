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
 **/

public class MarketingCloudVIPHandler {
    @future(callout=true)
    public static void callMarketingCloudVIPOpportunity(Id idTask){
        ContactDetail__c cDetail;
        Id idContact = null;
        Id idOpportunity = null;
        String userName;
        Map<String, Object> retornoWS;

        ExternalAPI__c apiVIP;
        apiVIP = ExternalAPI__c.getValues('MarketingCloudVIPOpportunity');

        Task task = [
            SELECT Id, OwnerId, CallDisposition, Category__c, Subcategory__c, Disposition__c, Reason__c, RecordTypeId, RecordType.Name, CreatedDate, WhoId, WhatId
            FROM Task
            WHERE Id = :idTask
        ];
        System.debug('task' + task);

        if(task != null){
            idContact = task.WhoId;
            Contact contact = [SELECT Id, FirstName, LastName, AccountId FROM Contact WHERE Id = :idContact];

            idOpportunity = task.WhatId;
            Opportunity opportunity = [SELECT Id, Name, StageName, CloseDate, DerivedFrom__c, OwnerId, Owner.Name FROM Opportunity WHERE Id = :idOpportunity];

            userName = opportunity.Owner.Name;

            List<ContactDetail__c> lstDetail = [
                SELECT Id, RelationshipGroup__c, MobilePhoneSMS__c, Email__c, Source__c, AssistantName__c, AssistantEmail__c, AssistantPhone__c
                FROM ContactDetail__c
                WHERE Contact__c = :idContact AND Source__c = 'CaixaSeguradora'
                LIMIT 1
            ];

            if(lstDetail.size() > 0){
                cDetail = lstDetail.get(0);
            }

            if(contact != null && opportunity != null){
                InputMarketingCloud input = new InputMarketingCloud();

                input.ContactKey = contact.Id;
                input.EventDefinitionKey = apiVIP.EventKey__c;
                input.EstablishContactKey = true;

                input.Data = new CustomData();

                //task
                input.Data.TaskID = task.Id;
                input.Data.OwnerId = task.OwnerId;
                input.Data.CallDisposition = task.CallDisposition;
                input.Data.Category = task.Category__c;
                input.Data.Subcategory = task.Subcategory__c;
                input.Data.Disposition = task.Disposition__c;
                input.Data.Reason = task.Reason__c;
                input.Data.RecordTypeID = task.RecordTypeId;
                input.Data.Tipo_Canal = task.RecordType.Name;
                input.Data.CreatedDate = task.CreatedDate;

                //contact
                input.Data.ContactID = contact.Id;
                input.Data.AcID = contact.AccountId;
                input.Data.NomeCliente = contact.FirstName + ' ' + contact.LastName;

                //user
                input.Data.Operador = userName;

                //opportunity
                input.Data.OpID = opportunity.Id;
                input.Data.OppName = opportunity.Name;
                input.Data.StageName = opportunity.StageName;
                input.Data.CloseDate = opportunity.CloseDate;
                input.Data.DerivedFrom = opportunity.DerivedFrom__c;

                //contactDetail
                if(cDetail != null){
                    input.Data.ContactDetailID = cDetail.Id;
                    input.Data.RelationshipGroup = cDetail.RelationshipGroup__c;

                    if(cDetail.AssistantName__c == null){
                        input.Data.Email = cDetail.Email__c;
                        input.Data.MobilePhone = cDetail.AssistantPhone__c;
                    }else{
                        input.Data.Email = cDetail.AssistantEmail__c;
                        input.Data.AssistantName = cDetail.AssistantName__c;
                        input.Data.MobilePhone = cDetail.MobilePhoneSMS__c;
                    }
                }

                //MarketingCloud
                input.Data.Locale = 'BR';

                CallMktCloudRest call = new CallMktCloudRest();
                retornoWS = call.PostMktCloudRest(JSON.serialize(input));
                System.debug('Input: ' + JSON.serialize(input));
                System.debug('Retorno do marketing cloud: ' + retornoWS);
            }
        }
    }

    @future(callout=true)
    public static void callMarketingCloudVIPAccount(Id idTask){
        Id idContact = null;
        Id idUser = null;
        ContactDetail__c cDetail;

        ExternalAPI__c apiVIP;
        apiVIP = ExternalAPI__c.getValues('MarketingCloudVIPAccount');

        Map<String, Object> retornoWS;

        Task task = [
            SELECT Id, OwnerId, CallDisposition, Category__c, Subcategory__c, Disposition__c, Reason__c, RecordTypeId, RecordType.Name, CreatedDate, WhoId, WhatId
            FROM Task
            WHERE Id = :idTask
        ];

        if(task != null){
            idContact = task.WhoId;
            Contact contact = [SELECT Id, FirstName, LastName, AccountId FROM Contact WHERE Id = :idContact];

            System.debug('idContact ' + idContact);

            idUser = task.OwnerId;
            User user = [SELECT Id, Name FROM User WHERE Id = :idUser];

            List<ContactDetail__c> lstDetail = [
                SELECT Id, RelationshipGroup__c, MobilePhoneSMS__c, Email__c, Source__c, AssistantName__c, AssistantEmail__c, AssistantPhone__c
                FROM ContactDetail__c
                WHERE Contact__c = :idContact AND Source__c = 'CaixaSeguradora'
                LIMIT 1
            ];

            if(lstDetail.size() > 0){
                cDetail = lstDetail.get(0);
            }

            InputMarketingCloud input = new InputMarketingCloud();

            input.ContactKey = contact.Id;
            input.EventDefinitionKey = apiVIP.EventKey__c;
            input.EstablishContactKey = true;

            input.Data = new CustomData();

            //task
            input.Data.TaskID = task.Id;
            input.Data.OwnerId = task.OwnerId;
            input.Data.CallDisposition = task.CallDisposition;
            input.Data.Category = task.Category__c;
            input.Data.Subcategory = task.Subcategory__c;
            input.Data.Disposition = task.Disposition__c;
            input.Data.Reason = task.Reason__c;
            input.Data.RecordTypeID = task.RecordTypeId;
            input.Data.Tipo_Canal = task.RecordType.Name;
            input.Data.CreatedDate = task.CreatedDate;

            //contact
            input.Data.ContactID = contact.Id;
            input.Data.AcID = contact.AccountId;
            input.Data.NomeCliente = contact.FirstName + ' ' + contact.LastName;

            //user
            input.Data.Operador = user.Name;

            //contactDetail
            if(cDetail != null){
                input.Data.ContactDetailID = cDetail.Id;
                input.Data.RelationshipGroup = cDetail.RelationshipGroup__c;

                if(cDetail.AssistantName__c == null){
                    input.Data.Email = cDetail.Email__c;
                    input.Data.MobilePhone = cDetail.AssistantPhone__c;
                }else{
                    input.Data.Email = cDetail.AssistantEmail__c;
                    input.Data.AssistantName = cDetail.AssistantName__c;
                    input.Data.MobilePhone = cDetail.MobilePhoneSMS__c;
                }
            }

            //MarketingCloud
            input.Data.Locale = 'BR';

            CallMktCloudRest call = new CallMktCloudRest();
            retornoWS = call.PostMktCloudRest(JSON.serialize(input));
            System.debug('Input: ' + JSON.serialize(input));
            System.debug('Retorno do marketing cloud: ' + retornoWS);
        }
    }

    public class InputMarketingCloud {
        String ContactKey { get; set; }
        String EventDefinitionKey { get; set; }
        Boolean EstablishContactKey { get; set; }
        CustomData Data { get; set; }
    }

    public class CustomData {
        //Task
        String TaskID { get; set; }
        String OwnerId { get; set; }
        String CallDisposition { get; set; }
        String Category { get; set; }
        String Subcategory { get; set; }
        String Disposition { get; set; }
        String Reason { get; set; }
        String RecordTypeID { get; set; }
        String Tipo_Canal { get; set; }
        Datetime CreatedDate { get; set; }

        //Contact
        String ContactID { get; set; }
        String AcID { get; set; }
        String NomeCliente { get; set; }

        //ContactDetail
        String ContactDetailID { get; set; }
        String RelationshipGroup { get; set; }
        String MobilePhone { get; set; }
        String Email { get; set; }
        String AssistantName { get; set; }

        //User
        String Operador { get; set; }

        //Opportunity
        String OpID { get; set; }
        String OppName { get; set; }
        String StageName { get; set; }
        Date CloseDate { get; set; }
        String DerivedFrom { get; set; }

        //MarketingCloud
        String Locale { get; set; }
    }
}