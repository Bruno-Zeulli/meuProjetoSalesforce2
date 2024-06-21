/**
* @description       :
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             :
* @last modified on  : 15-10-2021
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
* Modifications Log
* Ver   Date         Author                                Modification
* 1.0   15-10-2021   ChangeMeIn@UserSettingsUnder.SFDoc    Initial Version
* 1.1   15-01-2022   Samuel Sirkis                         Adicioando no mailing envio do WhoId
**/
public with sharing class CampaignIntegrationBO implements IOlosExecuteEvent {
    private List<OlosOrchestrationEvent__c> eventToUpdate = new List<OlosOrchestrationEvent__c>();
    private List<Campaign> campaignToUpdate = new List<Campaign>();
    private Map<String, OlosSetup__mdt> mapSetup = new Map<String, OlosSetup__mdt>();
    
    /**
* Processa a fila de produto
* @param eventId Id da fila de processamento
* @param recordId Id do registro de origem
* @param eventName nome do evento de processamento
* @param payload JSON com o item da fila para processamento
**/
    public void executeEvent(List<OlosOrchestrationEvent__c> eventsToProcessing){
        System.debug('<--------- executeEvent --------->');
        try{
            List<OlosSetup__mdt> olosSetupResult = [SELECT MasterLabel, Endpoint__c, Method__c FROM OlosSetup__mdt];
            
            System.debug('<--------- olosSetupResult --------->');
            
            for(OlosSetup__mdt olosSetup : olosSetupResult){
                System.debug(olosSetup);
                mapSetup.put(olosSetup.MasterLabel, olosSetup);
            }
            
            System.debug('<--------- OlosOrchestrationEvent --------->');
            
            for(OlosOrchestrationEvent__c event : eventsToProcessing){
                System.debug('>>>>>>>>>> Event ' + event);
                System.debug('>>>>>>>>>> Payload__c ' + event.Payload__c);
                sendToOlos(event.Id, event.RecordId__c, event.EventName__c, event.Payload__c);
            }
            
            // OlosProcessControl.ignoredByTrigger = true;
            // Make sure we can update the database before even trying
            if(!Schema.sObjectType.Campaign.isUpdateable() && !Schema.sObjectType.OlosOrchestrationEvent__c.isUpdateable()){
                System.debug('');
            }
            update campaignToUpdate;
            update eventToUpdate;
        } catch (Exception ex){
            System.debug(ex);
            // eventToUpdate.add(OlosOrchestrationBO.getInstance().sObjectUpdateEvent(eventId, eventName + ' / ' + ex.getMessage() + ' / ' + ex.getStackTraceString()));
        }
    }
    
    /**
* Envia os dados do SF para o Olos
* @param eventId Id da fila de processamento
* @param recordId Id do registro de origem
* @param eventName nome do evento de processamento
* @param payload JSON com o item da fila para processamento
*/
    private void sendToOlos(String eventId, String recordId, String eventName, String payload){
        System.debug('### payload => ' + payload);
        Map<String, TokenConfig__mdt> mapToken = new Map<String, TokenConfig__mdt>();
        
        // payload = payload.replace('\\"', '"');
        // payload = payload.replace('"{', '{');
        // payload = payload.replace('}"', '}');
        // payload = payload.replace(',"', '');
        payload = payload.replace('&quot;', '"');
        System.debug('### payload after => ' + payload);
        
        List<TokenConfig__mdt> olosTokenResult = [SELECT MasterLabel, CustomSettingId__c, CustomSettingProvider__c FROM TokenConfig__mdt];
        for(TokenConfig__mdt olosToken : olosTokenResult){
            mapToken.put(olosToken.MasterLabel, olosToken);
        }
        
        try{
            String userToken;
            String customSettingId;
            String customSettingProvider;
            
            if(mapToken.get('TOKEN_AUT') != null){
                if(
                    (mapToken.get('TOKEN_AUT').CustomSettingId__c != '' && mapToken.get('TOKEN_AUT').CustomSettingId__c != null) &&
                    (mapToken.get('TOKEN_AUT').CustomSettingProvider__c != '' &&
                     mapToken.get('TOKEN_AUT').CustomSettingProvider__c != null)
                ){
                    System.debug('<--------- sendToOlos --------->');
                    System.debug(mapToken.get('TOKEN_AUT'));
                    
                    customSettingId = mapToken.get('TOKEN_AUT').CustomSettingId__c;
                    customSettingProvider = mapToken.get('TOKEN_AUT').CustomSettingProvider__c;
                    userToken = Auth.AuthToken.getAccessToken(customSettingId, customSettingProvider);
                    
                    System.debug('>>>>>>>>>>>> Auth.AuthToken.getAccessToken ' + userToken);
                }
            }
            
            System.debug('<--------- SEND TO OLOS --------->');
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint(mapSetup.get(eventName).Endpoint__c);
            req.setMethod('POST');
            //req.setMethod( mapSetup.get( eventName ).Method__c );
            req.setHeader('Content-Type', 'application/json; charset=UTF-8');
            req.setHeader('Accept', 'application/json');
            
            if(userToken != '' && userToken != null){
                req.setHeader('Authorization', 'Bearer ' + userToken);
            }
            
            req.setTimeout(120000);
            req.setBody(payload);
            Http h = new Http();
            System.debug(req.getBody());
            System.debug(req.getBodyDocument());
            System.debug(req.getBodyAsBlob());
            System.debug(req.getEndpoint());

            HttpResponse res = h.send(req);
            System.debug('<--------- Retorno WS --------->');
            System.debug(res.getBody());
            
            if(res.getStatusCode() == 403 && (userToken != '' && userToken != null)){
                Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(customSettingId, customSettingProvider, userToken);
                String refreshUserToken = responseMap.get('AccessToken');
                // System.debug('>>>>>>>>>>>> Auth.AuthToken.refreshAccessToken ' + refreshUserToken);
                
                HttpRequest reqForbidden = new HttpRequest();
                reqForbidden.setEndpoint(mapSetup.get(eventName).Endpoint__c);
                reqForbidden.setMethod(mapSetup.get(eventName).Method__c);
                reqForbidden.setHeader('Content-Type', 'application/json; charset=UTF-8');
                reqForbidden.setHeader('Accept', 'application/json');
                
                if(refreshUserToken != '' && refreshUserToken != null){
                    reqForbidden.setHeader('Authorization', 'Bearer ' + refreshUserToken);
                }
                
                reqForbidden.setTimeout(120000);
                reqForbidden.setBody(payload);
                Http hToken = new Http();
                res = hToken.send(reqForbidden);
                System.debug(res);
            }
            
            if(res.getStatusCode() != 200){
                System.debug('ERROR');
                eventToUpdate.add(OlosOrchestrationBO.getInstance().sObjectUpdateEvent(eventId, res.getStatusCode() + ' / ' + res.getBody()));
                return;
            }else{
                System.debug('SUCCESS');
                eventToUpdate.add(OlosOrchestrationBO.getInstance().sObjectUpdateEvent(eventId, ''));
            }
            
            
            /*if(eventName.equals(OlosEventNames.INSERT_CAMPAIGN_MEMBER_SF_TO_OLOS.name())){
System.debug('');
}else if(eventName.equals(OlosEventNames.UPDATE_CAMPAIGN_MEMBER_SF_TO_OLOS.name())){
System.debug('');
}else if(eventName.equals(OlosEventNames.DELETE_CAMPAIGN_MEMBER_SF_TO_OLOS.name())){
System.debug('');
}else if(eventName.equals(OlosEventNames.INSERT_CAMPAIGN_SF_TO_OLOS.name())){
setResponseCreateAsCampaign(eventId, recordId, OlosUtil.getString(res.getStatusCode()), res.getBody());
}*/
        } catch (Exception ex){
            System.debug('<--------- Exception --------->');
            System.debug(ex);
            System.debug(ex.getCause());
            System.debug(ex.getMessage());
            System.debug(ex.getStackTraceString());
            eventToUpdate.add(OlosOrchestrationBO.getInstance().sObjectUpdateEvent(eventId, ex.getMessage() + ' / ' + ex.getStackTraceString()));
        }
    }
    /**
*   Classe para retorno da chamada de criação de campanha
*   @param eventId Id de referencia do processamento
*   @param recordId Id de referencia da origem do evento
*   @param statusCode Status da chamada ao serviço Olos
*   @param bodyResult Menssagem de retorno do processamento
*/
    //private void setResponseCreateAsCampaign(String eventId, String recordId, String statusCode, String bodyResult){
    // Map<String, Object> mapResponse = (Map<String, Object>) JSON.deserializeUntyped(bodyResult);
    // String message = OlosUtil.getBoolean(mapResponse.get('error')) ? OlosUtil.getString(mapResponse.get('message')) : '';
    
    // campaignToUpdate.add( new Campaign( Id = recordId, OlosStatusIntegracao__c = OlosUtil.getString( mapResponse.get( 'message' ) ) ) );
    // eventToUpdate.add(OlosOrchestrationBO.getInstance().sObjectUpdateEvent( eventId, statusCode + ' / ' + bodyResult ) );
    //}
    /**
* @description:
* @param event
*/
    public void callMethodSendOlos(OlosOrchestrationEvent__c event){
        if(Test.isRunningTest()){
            //sendToOlos( '1', '1', 'teste', 'teste');
            sendToOlos(event.Id, event.RecordId__c, event.EventName__c, event.Payload__c);
        }
    }
    /**
* Cria JSON com os dados do objeto
* @param campaignMember objeto de Membros da campanha para integração
* @param contact
* @param contactDetail
* @param campanha
* @param isUpdaten
* @param useExternal
*/
    public static String getInsertRecordDataRequestCampaignMember(
        CampaignMember campaignMember,
        Contact contact,
        ContactDetail__c contactDetail,
        Campaign campanha,
        Opportunity opportunity,
        Case caso,
        Boolean isUpdaten,
        Boolean useExternal
    ){
        System.debug('Start getInsertRecordDataRequestCampaignMember');
        System.debug(campaignMember);
        
        List<String> listFieldsSelect = new List<String>();
        List<String> listFieldsCustomSelect = new List<String>();
        List<OlosEntity.MediaData> listMediaData = new List<OlosEntity.MediaData>();
        
        OlosEntity.Fields fields;
        OlosEntity.MailingJson mailingJson;
        String customerId;
        String externalClassName;
        
        Map<String, OlosExtensionPhone__mdt> mapClass = new Map<String, OlosExtensionPhone__mdt>();
        List<OlosExtensionPhone__mdt> olosClassNameResult = [SELECT MasterLabel, ExternalClassName__c FROM OlosExtensionPhone__mdt];
        
        for(OlosExtensionPhone__mdt olosClassName : olosClassNameResult){
            // System.debug('>>>>> olosClassName ' + olosClassName);
            mapClass.put(olosClassName.MasterLabel, olosClassName);
            if(olosClassName.ExternalClassName__c != null && olosClassName.ExternalClassName__c != ''){
                externalClassName = olosClassName.ExternalClassName__c;
            }
        }
        
        if(!useExternal){
            externalClassName = '';
        }
        
        //CampaignMember
        // Campanha__c campanha = [SELECT Id, ID_Campanha_Olos__c, ID_Layout_Mailing_Olos__c, Nome_do_Mailing_Olos__c FROM Campanha__c WHERE Id = :campaignMember.Campanha__c];
        
        if(campaignMember.ContactId != null && campaignMember.ContactDetail__c != null){
            Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap();
            
            for(String fieldName : fieldMap.keySet()){
                if(fieldMap.get(fieldName).getDescribe().getType() == Schema.DisplayType.Phone){
                    System.debug(fieldName);
                    
                    if(fieldName != 'BestPhone__c' || fieldName != 'Best Phone'){ // Verifica se o campo não é BestPhone__c
                        String fieldLabel = fieldMap.get(fieldName).getDescribe().getLabel();
                        System.debug(fieldLabel);
                        System.debug(fieldMap.get(fieldName).getDescribe().getType());
                        
                        listFieldsSelect.add(fieldName);
                    }
                }
            }
            
            if(!listFieldsSelect.isEmpty() || externalClassName != ''){
                // String query =String.escapeSingleQuotes('SELECT Name,' + String.join(listFieldsSelect, ',') + ' FROM Contact WHERE Id = ');
                // query += '\'' + campaignMember.ContactId + '\' LIMIT 1' ;
                
                Contact record = contact;
                customerId = campaignMember.Id;
                
                if(externalClassName == ''){
                    listMediaData = getMediaData(listFieldsSelect, record);
                }else{
                    System.debug('externalPhones');
                    List<string> externalPhones = new List<string>();
                    
                    String fieldContact = '';
                    
                    Type t = Type.forName(externalClassName);
                    
                    Map<String, Schema.SObjectField> fieldMapExternal = Schema.getGlobalDescribe().get(externalClassName).getDescribe().fields.getMap();
                    
                    for(String fieldNameExternal : fieldMapExternal.keySet()){
                        if(fieldMapExternal.get(fieldNameExternal).getDescribe().getType() == Schema.DisplayType.Phone){
                            String fieldLabel = fieldMapExternal.get(fieldNameExternal).getDescribe().getLabel();
                            if(fieldLabel != 'BestPhone__c' || fieldLabel != 'Best Phone'){
                                listFieldsCustomSelect.add(fieldNameExternal);
                            }
                        }else if(
                            fieldMapExternal.get(fieldNameExternal).getDescribe().getLabel() == 'Contact' ||
                            fieldMapExternal.get(fieldNameExternal).getDescribe().getLabel() == 'Contato'
                        ){
                            fieldContact = fieldMapExternal.get(fieldNameExternal).getDescribe().getName();
                        }
                    }
                    
                    // System.debug(externalClassName);
                    
                    // System.debug(contactDetail);
                    
                    if(contactDetail != null){
                        // String queryCustom =String.escapeSingleQuotes('SELECT Name, Id,' + String.join(listFieldsCustomSelect, ',' ) + ' FROM ContactDetail__c WHERE Id = ');
                        // queryCustom += '\'' + contactDetail.Id + '\'';
                        // System.debug('### queryCustom => '+ queryCustom);
                        
                        ContactDetail__c record2 = contactDetail;
                        
                        // System.debug(record2);
                        
                        listMediaData = getMediaData(listFieldsCustomSelect, record2);
                    }
                    
                    System.debug(listMediaData);
                }
                // List<Contact> contacts = new List<Contact>(
                //     [SELECT IndividualIdentificationNumber__c FROM Contact WHERE Id =:campaignMember.ContactId LIMIT 1]);
                
                // System.debug('### contacts => ' + contacts);
                // System.debug('### contacts => ' + contacts[0].IndividualIdentificationNumber__c);
                
                // String queryCPF = String.escapeSingleQuotes('SELECT IndividualIdentificationNumber__c FROM Contact WHERE Id = ');
                // queryCPF += '\'' + campaignMember.ContactId + '\' LIMIT 1';
                // // String cpf = contactCPF[0];
                // System.debug(queryCPF);
                
                // Contact contactCPF = Database.query(queryCPF);
                // System.debug(contactCPF);
                
                //Enviando o CNPJ caso o contato não tenha CPF
                Account acc = [SELECT CompanyIdentificationNumber__c FROM Account WHERE Id = :contact.AccountId];
                String cpfCnpj;
                if(acc.CompanyIdentificationNumber__c == null){
                    cpfCnpj = contact.IndividualIdentificationNumber__c;
                }else{
                    cpfCnpj = acc.CompanyIdentificationNumber__c;
                }
                if( opportunity!= null){
                    fields = new OlosEntity.Fields(
                        customerId,
                        record.Name,
                        campaignMember.WhatId__c,
                        contact.Id,
                        campaignMember.Concierge_IncidentStatus__c,
                        opportunity.AgentName__c,
                        opportunity.Estrategia1__c,
                        opportunity.Estrategia2__c,
                        opportunity.Estrategia3__c,
                        opportunity.Estrategia4__c,
                        opportunity.Estrategia5__c
                    );
                }
                
                if( caso!= null){
                    fields = new OlosEntity.Fields(
                        customerId,
                        record.Name,
                        campaignMember.WhatId__c,
                        contact.Id,
                        campaignMember.Concierge_IncidentStatus__c,
                        caso.Owner.Name,
                        caso.Subject,
                        caso.Origin,
                        caso.Reason,
                        caso.Description,
                        caso.Concierge_IncidentWorkflowStatus__c
                    );
                }
                
                mailingJson = new OlosEntity.MailingJson(cpfCnpj, fields, listMediaData);
                System.debug('<--------- mailingJson --------->' + mailingJson);
                // System.debug('>>>>>>>>> CPF - ' + ContactCPF.IndividualIdentificationNumber__c);
                //String query2 = 'SELECT x from y';
                //SObject record2 = Database.query( query2 );
            }
            
            // List<Campaign> campanha = new List<Campaign>([
            //     SELECT Id, Nome_do_Mailing_Olos__c,  Id_Campanha_Olos__c, Id_Layout_Mailing_Olos__c, IDFinalizeDisposition__c
            //     FROM Campaign
            //     WHERE Id = :campaignMember.CampaignId
            //
            //     LIMIT 1
            // ]);
            
            JSONGenerator gen = JSON.createGenerator(false);
            gen.writeStartObject();
            gen.writeNumberField('LayoutId', campanha.ID_Layout_Mailing_Olos__c);
            gen.writeNumberField('CampaignId', campanha.ID_Campanha_Olos__c);
            gen.writeStringField('MailingName', campanha.Nome_do_Mailing_Olos__c);
            // gen.writeStringField('WhoId', campaignMember.ContacId);
            // gen.writeStringField('WhatId', campaignMember.OpportunityId);
            gen.writeStringField('json', JSON.serializePretty(mailingJson, true));
            gen.writeEndObject();
            
            String genString = gen.getAsString();
            // genString = genString.replace('\\"', '"');
            // genString = genString.replace('"{', '{');
            // genString = genString.replace('}"', '}');
            // genString = genString.replace('\n', '"');
            genString = genString.replace('&quot;', '"');
            System.debug('### genString => ' + genString);
            return genString;
        }else if(campaignMember.LeadId == null && campaignMember.ContactId == null){
            // TRATAMENTO DE ERRO PARA LEAD E CONTATO EM BRANCO
            System.debug('Lead or Contact not found');
        }
        
        return null;
    }  
    
    public static String getInsertRecordDataRequestCampaignMember(CampaignMember campaignMember, Contact contact, ContactDetail__c contactDetail, Campaign campanha, Opportunity opportunity, Case caso, Boolean isUpdaten, Boolean useExternal, Lead lead){
        System.debug(campaignMember);
        
        List<String> listFieldsSelect = new List<String>();
        List<String> listFieldsCustomSelect = new List<String>();
        List<OlosEntity.MediaData> listMediaData = new List<OlosEntity.MediaData>();
        
        OlosEntity.FieldsLeads fields;
        OlosEntity.MailingJsonLeads mailingJson;
        String customerId;
        String externalClassName;
        
        Map<String, OlosExtensionPhone__mdt> mapClass = new Map<String, OlosExtensionPhone__mdt>();
        List<OlosExtensionPhone__mdt> olosClassNameResult = [SELECT MasterLabel, ExternalClassName__c FROM OlosExtensionPhone__mdt];
        
        for(OlosExtensionPhone__mdt olosClassName : olosClassNameResult){
            mapClass.put(olosClassName.MasterLabel, olosClassName);
            if(olosClassName.ExternalClassName__c != null && olosClassName.ExternalClassName__c != ''){
                externalClassName = olosClassName.ExternalClassName__c;
            }
        }
        
        if(!useExternal){
            externalClassName = '';
        }
        
        if(campaignMember.LeadId != null){
            Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap();
            
            for(String fieldName : fieldMap.keySet()){
                if(fieldMap.get(fieldName).getDescribe().getType() == Schema.DisplayType.Phone){
                    System.debug(fieldName);
                    
                    String fieldLabel = fieldMap.get(fieldName).getDescribe().getLabel();
                    System.debug(fieldLabel);
                    System.debug(fieldMap.get(fieldName).getDescribe().getType());
                    
                    listFieldsSelect.add(fieldName);
                }
            }
            if(!listFieldsSelect.isEmpty() || externalClassName != ''){
                customerId = campaignMember.Id;
                
                listMediaData = getMediaData(listFieldsSelect, lead);

                if(lead != null){
                    fields = new OlosEntity.FieldsLeads(
                        lead.Id, //Id_Cliente_Salesforce
                        lead.Name, //Nome_Cliente_Salesforce
                        lead.Id, //Cliente_WhatId
                        lead.Id, //Cliente_WhoId
                        null, //Coringa4_Salesforce
                        null, //Coringa1_Salesforce
                        null, //Coringa2_Salesforce
                        null, //Coringa3_Salesforce
                        null, //Coringa6_Salesforce
                        null, //Coringa7_Salesforce
                        null, //Coringa8_Salesforce
                        null, //ContactDispositionId
                        null //ContactDisposition
                    );
                }
                mailingJson = new OlosEntity.MailingJsonLeads(campaignMember.Id, fields, listMediaData);
                System.debug('<--------- mailingJson --------->' + mailingJson);
                JSONGenerator gen = JSON.createGenerator(false);
                gen.writeStartObject();
                gen.writeNumberField('LayoutId', campanha.ID_Layout_Mailing_Olos__c);
                gen.writeNumberField('CampaignId', campanha.ID_Campanha_Olos__c);
                gen.writeStringField('MailingName', campanha.Nome_do_Mailing_Olos__c);
                gen.writeStringField('json', JSON.serializePretty(mailingJson, true));
                gen.writeEndObject();
                
                String genString = gen.getAsString();
                genString = genString.replace('&quot;', '"');
                System.debug('### genString => ' + genString);
                return genString;
            }
            
        }else if(campaignMember.LeadId == null && campaignMember.ContactId == null){
            // TRATAMENTO DE ERRO PARA LEAD E CONTATO EM BRANCO
            System.debug('Lead or Contact not found');
        }
        
        return null;
    }
    
    
    /**
* @description
* @param campaignMember
*/
    public static String getFinalizeClienteRequestCampaignMember(CampaignMember campaignMember){
        Campaign campanhaSales = [
            SELECT Id, ID_Campanha_Olos__c, ID_Layout_Mailing_Olos__c, Nome_do_Mailing_Olos__c, IDFinalizeDisposition__c
            FROM Campaign
            WHERE Id = :campaignMember.CampaignId
            
        ];
        
        // System.debug('>>>>>>>>> getFinalizeClienteRequestCampaignMember');
        // System.debug(campanhaSales);
        // System.debug(campaignMember.CampaignId);
        
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeNumberField('DispositionId', OlosUtil.getInteger(campanhaSales.IDFinalizeDisposition__c));
        gen.writeStringField('MailingName', OlosUtil.getString(campanhaSales.Nome_do_Mailing_Olos__c));
        gen.writeStringField('CustomerId', OlosUtil.getString(campaignMember.Id));
        gen.writeEndObject();
        
        return gen.getAsString();
    }
    /**
* @description:
* @param listFields
* @param record
* @return listMediaData
*/
    private static List<OlosEntity.MediaData> getMediaData(List<String> listFields, SObject record){
        OlosEntity.Addr addr;
        OlosEntity.MediaData mediaData;
        List<OlosEntity.MediaData> listMediaData = new List<OlosEntity.MediaData>();
        
        System.debug('<--------- getMediaData --------->');
        for(String item : listFields){
            String phoneNumber = (String) record.get(item);
            System.debug('item: ' + item);
            if(item != 'BestPhone__c' || item != 'Best Phone'){
                if(phoneNumber != null){
                    if(phoneNumber.length() > 11 && phoneNumber.indexOf('01155') >= 0){
                        phoneNumber = phoneNumber.substring(5);
                    }
                    
                    if((phoneNumber.length() > 11) && (phoneNumber.substring(0, 2) == '55')){
                        phoneNumber = phoneNumber.substring(2, phoneNumber.length());
                    }
                    
                    String dddPhone = phoneNumber.substring(0, 2);
                    String ddrPhone = phoneNumber.substring(2, phoneNumber.length());
                    addr = new OlosEntity.Addr(dddPhone, ddrPhone);
                    mediaData = new OlosEntity.MediaData(addr);
                    listMediaData.add(mediaData);
                }
            }
        }
        return listMediaData;
    }
    /**
* @Description:
* @param query
* @return Database.query(query)
*/
    private static Contact olosDatabaseQuery(String query){
        return Database.query(query);
    }
}