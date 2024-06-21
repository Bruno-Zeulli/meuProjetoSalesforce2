public without sharing class GenesysAddContactListMember implements Queueable, Database.AllowsCallouts{
    private Set<Id> campaignMemberIds;
    private Boolean isUpdateContext = false;

    public GenesysAddContactListMember(Set<Id> campaignMemberIds){
        this.campaignMemberIds = campaignMemberIds;
    }
    
    public GenesysAddContactListMember(Set<Id> campaignMemberIds, Boolean isUpdateContext){
        this.campaignMemberIds = campaignMemberIds;
        this.isUpdateContext = isUpdateContext;
    }

    public void execute(QueueableContext context) {
        Map<Id, CampaignMember> mapMembers = new Map<Id, CampaignMember>(
            [
                SELECT
                    Id,
                    Name,
                    LeadId,
                    Phone,
                    MobilePhone,
                    Email,
                    CampaignId,
                    ContactId,
                    ContactDetail__c,
                    WhatId__c,
                    Contrato__c,
                    CreatedDate,
                    LastModifiedDate,
                    Priority__c,
                    Campaign.PureCloud_Contact_List_ID__c,
                    Contact.Name,
                    Contact.AccountId,
                    Contact.Account.IdentificationNumber__c,
                    ContactDetail__r.Name,
                    ContactDetail__r.Email__c,
                    ContactDetail__r.MobilePhone__c,
                    ContactDetail__r.BestPhone__c,
                    ContactDetail__r.AssistantPhone__c,
                    ContactDetail__r.OtherPhone__c,
                    ContactDetail__r.HomePhone__c,
                    Lead.var2__c,
                    Lead.var3__c,
                    Lead.var4__c,
                    Lead.var5__c,
                    Lead.var6__c,
                    Lead.var7__c,
                    Lead.var8__c,
                    Lead.var9__c,
                    Lead.var10__c,
                    Lead.Name,
                    Lead.MobilePhone,
                    Lead.IdentificationNumber__c,
                    Lead.Phone,
                    Lead.Email,
                    Contrato__r.StartDate__c
                FROM CampaignMember
                WHERE
                    Id = :campaignMemberIds
                    AND Campaign.CTI_Name__c = 'Genesys'
            ]
        );

        if (mapMembers.isEmpty()) {
            return;
        }

        Map<Id, Opportunity> mapOpportunity = new Map<Id, Opportunity>();
        for (CampaignMember member : mapMembers.values()) {
            if (
                String.isNotBlank(member.WhatId__c) &&
                ((Id) member.WhatId__c)
                    .getSObjectType()
                    .getDescribe()
                    .getName() == 'Opportunity'
            ) {
                mapOpportunity.put(member.WhatId__c, new Opportunity());
            }
        }

        if (!mapOpportunity.isEmpty()) {
            mapOpportunity = new Map<Id, Opportunity>(
                [
                    SELECT
                        Id,
                        AgentName__c,
                        Estrategia1__c,
                        Estrategia2__c,
                        Estrategia3__c,
                        Estrategia4__c,
                        Estrategia5__c
                    FROM Opportunity
                    WHERE Id = :mapOpportunity.keySet()
                ]
            );
        }

        List<Map<String, Object>> requestBody = new List<Map<String, Object>>();

        System.debug('Contexto de Update? ' + isUpdateContext);

        for (CampaignMember member : mapMembers.values()) {
            Map<String, Object> contactBody = new Map<String, Object>();

            String dataCarga = isUpdateContext ? 
                    (String) member.LastModifiedDate.format('yyyy-MM-dd\'T\'HH:mm\'Z\'', 'America/Sao_Paulo'):
                    (String) member.CreatedDate.format('yyyy-MM-dd\'T\'HH:mm\'Z\'', 'America/Sao_Paulo');

            contactBody.put(
                'contactListId',
                member.Campaign.PureCloud_Contact_List_ID__c
            );

            /*
            ((Map<String, Object>) contactBody.get('data'))
                .put('Estrategia1', opp.Estrategia1__c);
            ((Map<String, Object>) contactBody.get('data'))
                .put('Estrategia2', opp.Estrategia2__c);
            ((Map<String, Object>) contactBody.get('data'))
                .put('Estrategia3', opp.Estrategia3__c);
            ((Map<String, Object>) contactBody.get('data'))
                .put('Estrategia4', opp.Estrategia4__c);
            ((Map<String, Object>) contactBody.get('data'))
                .put('Estrategia5', opp.Estrategia5__c);
            */
            Opportunity opp = mapOpportunity.containsKey(member.WhatId__c)
                ? mapOpportunity.get(member.WhatId__c)
                : new Opportunity();
            
            contactBody.put(
                'data',
                new Map<String, String>{
                    'Nome' => String.isBlank(member.Contact.Name)
                        ? member.Lead.Name
                        : member.Contact.Name,
                    'CPF_CNPJ' => String.isBlank(member.Contact.Name)
                        ? member.Lead.IdentificationNumber__c
                        : member.Contact.Account.IdentificationNumber__c,
                    'Email' => String.isBlank(member.Contact.Name)
                        ? member.Lead.Email
                        : member.ContactDetail__r.Email__c,
                    'Telefone1' => String.isBlank(member.ContactDetail__r.MobilePhone__c)
                        ? member.Lead.MobilePhone
                        : member.ContactDetail__r.MobilePhone__c,
                    'Telefone2' => String.isBlank(member.ContactDetail__r.BestPhone__c)
                        ? member.Lead.Phone
                        : member.ContactDetail__r.BestPhone__c,
                    'Telefone3' => String.isBlank(member.ContactDetail__r.BestPhone__c)
                        ? member.Lead.var8__c
                        : member.ContactDetail__r.BestPhone__c,
                    'Telefone4' =>  String.isBlank(member.ContactDetail__r.HomePhone__c)
                        ? member.Lead.var9__c
                        : member.ContactDetail__r.HomePhone__c,
                    'Telefone5' => String.isBlank(member.ContactDetail__r.HomePhone__c)
                        ? member.Lead.var10__c
                        : member.ContactDetail__r.HomePhone__c,
                    'WhatId' => member.WhatId__c,
                    'AccountId' => member.Contact.AccountId,
                    'ContactId' => member.ContactId,
                    'ContactDetailId' => member.ContactDetail__c,
                    'CampaignMemberId' => member.Id,
                    'ContractId' => member.Contrato__c,
                    'Aux1' => !String.isBlank(opp.Estrategia1__c)
                        ? opp.Estrategia1__c
                        : member.Lead.var2__c,
                    'Aux2' =>  !String.isBlank(opp.Estrategia2__c)
                        ? opp.Estrategia2__c
                        : member.Lead.var3__c,
                    'Aux3' =>  !String.isBlank(opp.Estrategia3__c)
                        ? opp.Estrategia3__c
                        : member.Lead.var4__c,
                    'Aux4' =>  !String.isBlank(opp.Estrategia4__c)
                        ? opp.Estrategia4__c
                        : member.Lead.var5__c,
                    'Aux5' =>  !String.isBlank(opp.Estrategia5__c)
                        ? opp.Estrategia5__c
                        : member.Lead.var6__c,
                    'Aux6' => !String.isBlank(member.Lead.var7__c)
                        ? member.Lead.var7__c
                        : '',
                    'Aux7' => '',
                    'Aux8' => '',
                    'Aux9' => '',
                    'Sistema1' => '',
                    'Sistema2' => '',
                    'Sistema3' => '',
                    'Sistema4' => '',
                    'Sistema5' => '',
                    'Prioridade' => String.isBlank(String.valueOf(member.Priority__c)) ? '' : String.valueOf(member.Priority__c),
                    'DataCarga' => dataCarga,
                    'DataAlocacao' => member.Contrato__r.StartDate__c == null
                        ? ''
                        : DateTime.newInstanceGMT(
                                  member.Contrato__r.StartDate__c.year(),
                                  member.Contrato__r.StartDate__c.month(),
                                  member.Contrato__r.StartDate__c.day()
                              )
                              .formatGmt('yyyy-MM-dd\'T\'HH:mm\'Z\''),
                    'FusoHorario' => 'America/Sao_Paulo'
                }
            );
            
            ((Map<String, Object>) contactBody.get('data'))
                .put('AgentId', opp.AgentName__c );

            contactBody.put('callable', true);

            contactBody.put(
                'phoneNumberStatus',
                new Map<String, Object>{
                    'Telefone1' => new Map<String, Object>{ 'callable' => true }
                }
            );

            contactBody.put(
                'contactableStatus',
                new Map<String, Object>{
                    'Email' => new Map<String, Object>{ 'contactable' => true }
                }
            );
            requestBody.add(contactBody);
        }

        System.debug('Corpo request: ');
        System.debug(JSON.serialize(requestBody));

        String jsonResponse = GenesysIntegrationService.createContacts(
            JSON.serialize(requestBody),
            mapMembers.values()[0].Campaign.PureCloud_Contact_List_ID__c
        );

        Response[] responses = (Response[]) JSON.deserialize(
            jsonResponse,
            List<Response>.class
            );
            
        System.debug('Corpo response: ');
        System.debug(jsonResponse);
        System.debug(responses);

        for (Response response : responses) {
            if (mapMembers.containsKey(response?.data?.CampaignMemberId)) {
                mapMembers.get(response.data.CampaignMemberId)
                    .ReferenceId__c = response.id;
            }
        }
        update mapMembers.values();
    }

    public class Response {
        public String id;
        public Data data;
    }

    public class Data {
        public String CampaignMemberId;
    }
}