public without sharing class ExpiredTabulacaoQueueable  implements Queueable, Database.AllowsCallouts{
    private CallLogMessageJson2Apex callLogMessage;
    private String tabulationRefId;

    public ExpiredTabulacaoQueueable(CallLogMessageJson2Apex callLogMessage, String tabulationRefId){
        this.callLogMessage = callLogMessage;
        this.tabulationRefId = tabulationRefId;
    }

    public void execute(QueueableContext context) {
        System.debug('@ExpiredTabulacaoQueueable');
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
                    Lead.IdentificationNumber__c,
                    Lead.MobilePhone,
                    Lead.Phone,
                    Lead.Email,
                    Contrato__r.StartDate__c
                FROM CampaignMember
                WHERE
                    ReferenceId__c =: callLogMessage.dialerContactId
                    AND Campaign.CTI_Name__c = 'Genesys'
            ]
        );

        DispositionPath__c tab = [SELECT Id, Reason__c FROM DispositionPath__c WHERE ExternalId__c =:tabulationRefId];

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

        for (CampaignMember member : mapMembers.values()) {
            Map<String, Object> contactBody = new Map<String, Object>();

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
                        ? ''+opp.Estrategia1__c
                        : ''+member.Lead.var2__c,
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
                    'Sistema1' => tab.Reason__c,
                    'Sistema2' => '',
                    'Sistema3' => '',
                    'Sistema4' => '',
                    'Sistema5' => '',
                    'Prioridade' => String.isBlank(String.valueOf(member.Priority__c)) ? '' : String.valueOf(member.Priority__c),
                    'DataCarga' => member.CreatedDate.formatGmt(
                        'yyyy-MM-dd\'T\'HH:mm\'Z\''
                    ),
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

            requestBody.add(contactBody);
        }

        System.debug('Corpo requestBody: ');
        System.debug(JSON.serialize(requestBody));

        String jsonResponse = GenesysIntegrationService.putTabulacao(
            this.callLogMessage.dialerContactId,
            this.callLogMessage.dialerContactListId,
            JSON.serialize(requestBody[0])
        );

        System.debug('Corpo request2: ');
        System.debug(JSON.serialize(requestBody));
        
        System.debug('Corpo response: ');
        System.debug(jsonResponse);
        
    }

    public class Response {
        public String id;
        public Data data;
    }

    public class Data {
        public String CampaignMemberId;
    }
}