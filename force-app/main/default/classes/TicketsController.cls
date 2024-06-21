public class TicketsController {

    public static String recordTypeTkt = '_Tkt';

    @AuraEnabled
    public static String getTickets(){
        List<TicketTO> tickets = new List<TicketTO>();
        Set<String> setContactsIds = new Set<String>();
        Set<Id> caseIdSet = new Set<Id>();
        Map<String, ContactDetail__c> mapContacsDetailsByContactId = new Map<String, ContactDetail__c>();
        Map<Id, String> caseMotivoMap = new Map<Id, String>();
        Map<Id, String> caseTipoMap = new Map<Id, String>();
        Map<Id, String> caseSubtipoMap = new Map<Id, String>();

        Set<Id> lUserOrGroupIds = (Set<ID>) (JSON.deserialize(getUserOrGroupIds(), Set<Id>.class));
        List<Case> cases = CaseDao.getInstance().getCasesByOwnerIds(lUserOrGroupIds);

        for(Case caso : cases){
            if(caso.Contact.Id != null){
                setContactsIds.add(caso.Contact.Id);
            }
            caseIdSet.add(caso.Id);
        }

        for(ContactDetail__c contactDetail : [  SELECT  Id,
                                                        Name,
                                                        Email__c,
                                                        Contact__c
                                                FROM    ContactDetail__c
                                                WHERE   Contact__c IN :setContactsIds ]
        ){
            mapContacsDetailsByContactId.put(contactDetail.Contact__c, contactDetail);
        }

        List<Task> tasksList = [SELECT Id, Disposition__r.Group__c, Disposition__r.Category__c, Disposition__r.Reason__c, Disposition__r.SpecificReason__c, WhatId  FROM Task WHERE WhatId IN: caseIdSet AND Disposition__r.Group__c != null ORDER BY CreatedDate ASC];


        for(Task iTask : tasksList){
            caseMotivoMap.put(iTask.WhatId, iTask.Disposition__r.Category__c);
            caseTipoMap.put(iTask.WhatId, iTask.Disposition__r.Reason__c);
            caseSubtipoMap.put(iTask.WhatId, iTask.Disposition__r.SpecificReason__c);
        }

        for(Case caso : cases){
            ContactDetail__c contactDetail = mapContacsDetailsByContactId.get(caso.Contact.Id);

            TicketTO ticket = convertCaseInTicket(caso, contactDetail, caseMotivoMap, caseTipoMap, caseSubtipoMap);

            tickets.add(ticket);
        }

        System.debug('https://wiz--territory.my.salesforce.com/_ui/common/apex/debug/ApexCSIPage =>'+tickets);

        return JSON.serialize(tickets);
    }

    public static TicketTO convertCaseInTicket(Case caso, ContactDetail__c contactDetail, Map<Id, String> motivoValueMap, Map<Id, String> tipoValueMap, Map<Id, String> subtipoValueMap){
        TicketTO ticket = new TicketTO();
            ticket.id = caso.Id;
            ticket.caseNumber = caso.CaseNumber;
            ticket.dataCriacao = caso.CreatedDate;
            ticket.createdDateToFilter = caso.CreatedDate.date();
            ticket.dataModificacao = caso.LastModifiedDate;

            ticket.prioridade = caso.Priority;

            if(ticket.prioridade == 'Low'){
                ticket.prioridadeFormatada = 'Baixo';
            }else if(ticket.prioridade == 'Medium'){
                ticket.prioridadeFormatada = 'Médio';
            }else  if(ticket.prioridade == 'High'){
                ticket.prioridadeFormatada = 'Alto';
            }

            ticket.status = caso.Status;

            if(ticket.status == 'Closed'){
                ticket.statusFormatado = 'Fechado';
            }else if(ticket.status == 'New'){
                ticket.statusFormatado = 'Novo';
            }else{
                ticket.statusFormatado = ticket.status;
            }

            ticket.motivo = motivoValueMap.get(caso.Id);
            ticket.tipo = tipoValueMap.get(caso.Id);
            ticket.nota = caso.NPS__c;
            ticket.subtipo = subtipoValueMap.get(caso.Id);
            ticket.procedente = caso.Procedente_Tkt__c;

            if(caso.Contact != null){
                ticket.contact = new TicketTO.Contact();
                ticket.contact.id = caso.Contact.Id;
                ticket.contact.name = caso.Contact.Name;
            }else{
                ticket.contact = new TicketTO.Contact();
                ticket.contact.id = '';
                ticket.contact.name = '';

            }

            if(caso.Owner != null){
                ticket.owner = new TicketTO.Owner();
                ticket.owner.id = caso.Owner.Id;
                ticket.owner.name = caso.Owner.Name;
            }

            if(caso.RecordType != null){
                ticket.recordtype = new TicketTO.RecordType();
                ticket.recordtype.id = caso.RecordType.Id;
                ticket.recordtype.name = caso.RecordType.Name;
                ticket.recordtype.developerName = caso.RecordType.DeveloperName;
            }

            if(contactDetail != null){
                caso.ContactDetail__c = contactDetail.Id;
                ticket.contactDetail = new TicketTO.ContactDetail();
                ticket.contactDetail.id = contactDetail.Id;
                ticket.contactDetail.name = contactDetail.Name;
                ticket.contactDetail.email = contactDetail.Email__c;
            }else{
                ticket.contactDetail = new TicketTO.ContactDetail();
                ticket.contactDetail.id = '';
                ticket.contactDetail.name = '';
                ticket.contactDetail.email = '';
            }

            return ticket;

    }

    @AuraEnabled
    public static List<String> getUserOrGroupNames(){
        Map<String, Set<String>> mapUserOrGroup = getMapUserOrGroup();
        List<String> lUserOrGroupName = new List<String>();

        for(String userName : mapUserOrGroup.get('Name')){
            lUserOrGroupName.add(userName);
        }

        return lUserOrGroupName;
    }

    @AuraEnabled
    public static String getUserOrGroupIds(){
        Map<String, Set<String>> mapUserOrGroup = getMapUserOrGroup();

        return JSON.serialize(mapUserOrGroup.get('Id'));
    }

    private static Map<String, Set<String>> getMapUserOrGroup(){
        Set<String> lUserIdOrGroupId = new Set<String>();
        Set<Id> lUserId = new Set<Id>();
        Set<String> lUserOrGroupName = new Set<String>();
        Map<String, Set<String>> mapUserOrGroup = new Map<String, Set<String>>();
        String profileRef;

        Id userId = UserInfo.getUserId();
        User objUserCurrent = [SELECT Profile.Name FROM User WHERE Id = :userId LIMIT 1];

        if( objUserCurrent.Profile.Name.contains('Administrador') &&
            objUserCurrent.Profile.Name.contains('Developer') &&
            objUserCurrent.Profile.Name.contains('Integrador'))
        {
            profileRef = objUserCurrent.Profile.Name;
        }else{

            String prefixProfile = objUserCurrent.Profile.Name.substringBefore(' ');
            profileRef = prefixProfile + ' - Tickets';
        }

        for(GroupMember objGroupMember : [ SELECT   Id,
                                                    UserOrGroupId,
                                                    GroupId,
                                                    Group.Name
                                            FROM    GroupMember
                                            WHERE   UserOrGroupId IN (  SELECT  Id
                                                                        FROM    USER
                                                                        WHERE   Profile.Name = :profileRef
                                                                        OR     Id = :userId)
                                            AND Group.Type = 'Queue']
        ){
            lUserIdOrGroupId.add(String.valueOf(objGroupMember.GroupId));
            lUserOrGroupName.add(objGroupMember.Group.Name);
            lUserIdOrGroupId.add(String.valueOf(objGroupMember.UserOrGroupId));
            lUserId.add(objGroupMember.UserOrGroupId);
        }

        for(User objUser : [ SELECT Id, Name FROM User WHERE Id IN:lUserId]){
            lUserOrGroupName.add(objUser.Name);
        }

        lUserIdOrGroupId.add(userId);
        mapUserOrGroup.put('Name', lUserOrGroupName);
        mapUserOrGroup.put('Id', lUserIdOrGroupId);

        return mapUserOrGroup;
    }


     @AuraEnabled
     public static List<RecordType> getRecordTypeTicketlist(){
        List<RecordType> recordTypesList = new List<RecordType>();
        Schema.DescribeSObjectResult result = case.SObjectType.getDescribe();
        List<Schema.RecordTypeInfo> recordTypes = result.getRecordTypeInfos();
        Set<String> listRecordTypesNames = new Set<String>();
        Map<String, Id> mapOwnerIdsOfRecordtypesCaseAssigmentRules = new Map<String, Id>();

        for( Schema.RecordTypeInfo recordTypeVal : recordTypes){
            if(recordTypeVal.DeveloperName.contains(recordTypeTkt)){
                listRecordTypesNames.add(recordTypeVal.Name);
            }
        }

        List<Group> filasTickets = [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND Name IN :listRecordTypesNames];

        for(Group fila :  filasTickets){
            mapOwnerIdsOfRecordtypesCaseAssigmentRules.put(fila.Name, fila.Id);
        }

        for( Schema.RecordTypeInfo recordTypeVal : recordTypes){
            if(recordTypeVal.DeveloperName.contains(recordTypeTkt)){
                Id filaId = mapOwnerIdsOfRecordtypesCaseAssigmentRules.get(recordTypeVal.Name);
                System.debug('filaId ==>'+ filaId);

                RecordType tipoRegistro = new RecordType();
                tipoRegistro.Id =  recordTypeVal.getRecordTypeId();
                tipoRegistro.Name = recordTypeVal.Name;
                tipoRegistro.DeveloperName = recordTypeVal.DeveloperName;
                tipoRegistro.Description = filaId;
                recordTypesList.add(tipoRegistro);
            }

        }
        return recordTypesList;
     }

     @AuraEnabled
     public static Id getRecordTypeIdByGrupoName(String nomeRecordType){
        return [SELECT Id FROM RecordType WHERE Name =:nomeRecordType].Id;

     }

     @AuraEnabled
     public static void updateRecordType(String recordTypeSelected, Id caseRecordId){
        Case iCaseToUpdate = [SELECT Id, RecordTypeId FROM Case WHERE Id =: caseRecordId];
        iCaseToUpdate.RecordTypeId = recordTypeSelected;
        update iCaseToUpdate;
     }

     @AuraEnabled
     public static String getRecordTypeName(Id caseRecordId){
        return [SELECT Id, RecordType.Name FROM Case WHERE Id =: caseRecordId].RecordType.Name;
     }

     @AuraEnabled
     public static List<String> getProdutoOptions(){
        Set<String> produtoOptionsSet = new Set<String>();
        List<String> lstProdutoOptions = new List<String>();
        for(DispositionPath__c lstToIterate : [SELECT Product__c FROM DispositionPath__c WHERE UN__c = 'Parceiros' AND Product__c != 'CGI Wimo' ORDER BY Product__c ASC]){
            produtoOptionsSet.add(lstToIterate.Product__c);
        }
        for(String iProdutoOptionsSet : produtoOptionsSet){
            lstProdutoOptions.add(iProdutoOptionsSet);
        }
        return lstProdutoOptions;
     }

     @AuraEnabled
     public static List<String> getBandeiraOptions(String produtoToSearch){
        Set<String> bandeiraOptionsSet = new Set<String>();
        List<String> lstBandeiraOptions = new List<String>();
        for(DispositionPath__c lstToIterate : [SELECT UNProduct__c FROM DispositionPath__c WHERE UN__c = 'Parceiros' AND Product__c =: produtoToSearch ORDER BY UNProduct__c ASC]){
            bandeiraOptionsSet.add(lstToIterate.UNProduct__c);
        }
        for(String iBandeiraOptionsSet : bandeiraOptionsSet){
            lstBandeiraOptions.add(iBandeiraOptionsSet);
        }
        return lstBandeiraOptions;
     }

     @AuraEnabled
     public static List<String> getGroupOptions(String produtoToSearch, String bandeiraToSearch){
        Set<String> groupOptionsSet = new Set<String>();
        List<String> lstGroupOptions = new List<String>();
        for(DispositionPath__c lstToIterate : [SELECT Group__c FROM DispositionPath__c WHERE UN__c = 'Parceiros' AND UNProduct__c =: bandeiraToSearch AND Product__c =:produtoToSearch  ORDER BY Group__c ASC]){
            groupOptionsSet.add(lstToIterate.Group__c);
        }
        for(String iGroupOptionsSet : groupOptionsSet){
            lstGroupOptions.add(iGroupOptionsSet);
        }
        return lstGroupOptions;
     }

    @AuraEnabled
     public static List<String> getMotivoOptions(String groupToSearch){
        Set<String> motivoOptionsSet = new Set<String>();
        List<String> lstMotivoOptions = new List<String>();
        for(DispositionPath__c lstToIterate : [SELECT Category__c, Group__c FROM DispositionPath__c WHERE UN__c = 'Parceiros' AND Group__c =:groupToSearch ORDER BY Category__c ASC]){
            motivoOptionsSet.add(lstToIterate.Category__c);
        }
        for(String iMotivoOptionsSet : motivoOptionsSet){
            lstMotivoOptions.add(iMotivoOptionsSet);
        }
        return lstMotivoOptions;
     }

    @AuraEnabled
     public static List<String> getTipoOptions(String groupToSearch, String motivoToSearch){
        Set<String> tipoOptionsSet = new Set<String>();
        List<String> lstTipoOptions = new List<String>();
        for(DispositionPath__c lstToIterate : [SELECT Category__c, Group__c, Disposition__c FROM DispositionPath__c WHERE UN__c = 'Parceiros' AND Group__c =:groupToSearch AND Category__c =:motivoToSearch  ORDER BY Disposition__c ASC]){
            tipoOptionsSet.add(lstToIterate.Disposition__c);
        }
        for(String iTipoOptionsSet : tipoOptionsSet){
            lstTipoOptions.add(iTipoOptionsSet);
        }
        return lstTipoOptions;
     }

    @AuraEnabled
     public static List<String> getSubtipoOptions(String groupToSearch, String motivoToSearch, String tipoToSearch){
        Set<String> subtipoOptionsSet = new Set<String>();
        List<String> lstSubtipoOptions = new List<String>();
        for(DispositionPath__c lstToIterate : [SELECT Category__c, Group__c, Disposition__c, SpecificReason__c FROM DispositionPath__c WHERE UN__c = 'Parceiros' AND Group__c =:groupToSearch AND Category__c =:motivoToSearch AND Disposition__c =:tipoToSearch  ORDER BY Disposition__c ASC]){
            subtipoOptionsSet.add(lstToIterate.SpecificReason__c);
        }
        for(String iSubtipoOptionsSet : subtipoOptionsSet){
            lstSubtipoOptions.add(iSubtipoOptionsSet);
        }
        return lstSubtipoOptions;
     }

     @AuraEnabled
     public static Id getDispositionPath(String groupToSearch, String tipoToSearch, String motivoToSearch, String subtipoToSearch){
        String query = 'SELECT Id FROM DispositionPath__c WHERE Group__c =: groupToSearch AND Category__c =: motivoToSearch AND Disposition__c =: tipoToSearch';
        if(subtipoToSearch != ''){
            query += ' AND SpecificReason__c =: subtipoToSearch';
        }
        query += ' AND UN__c = \'Parceiros\' LIMIT 1';
        DispositionPath__c dispositionPathId = Database.query(query);

        return dispositionPathId.Id;
    }

     @AuraEnabled
     public static void createTask(String contactId, String caseId, String caseDescription, String tipoValue, String groupValue, String motivoValue, String subtipoValue, String produtoValue, String bandeiraValue){
        Id taskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Parceiros_Tickets').getRecordTypeId();

        Case caseToUpdate = [SELECT Id, Produto_Tkt__c, Bandeira_Tkt__c, Grupo_Tkt__c, Motivo_Tkt__c, Tipo_Tkt__c, Subtipo_Tkt__c FROM Case WHERE Id =: caseId];
        caseToUpdate.Produto_Tkt__c = produtoValue;
        caseToUpdate.Bandeira_Tkt__c = bandeiraValue;
        caseToUpdate.Grupo_Tkt__c = groupValue;
        caseToUpdate.Motivo_Tkt__c = motivoValue;
        caseToUpdate.Tipo_Tkt__c = tipoValue;
        caseToUpdate.Subtipo_Tkt__c = subtipoValue;


        Task iTask = new Task();
        iTask.OwnerId = UserInfo.getUserId();
        iTask.Priority = 'Normal';
        iTask.ActivityDate = System.Today();
        iTask.WhoId = contactId;
        iTask.WhatId = caseId;
        iTask.Description = caseDescription;
        iTask.RecordTypeId = taskRecordTypeId;
        iTask.Disposition__c = TicketsController.getDispositionPath(groupValue, tipoValue, motivoValue, subtipoValue);
        iTask.Subject = tipoValue;
        iTask.Status = 'Completed';

        insert iTask;
        update caseToUpdate;

     }

    @AuraEnabled
     public static List<Task> verifyTasks(String caseRecordId){
        List<Task> tasksToReturn = [SELECT Id, Disposition__r.Product__c, Disposition__r.UNProduct__c, Disposition__r.Group__c, Disposition__r.Category__c, Disposition__r.Reason__c, Disposition__r.SpecificReason__c  FROM Task WHERE WhatId =: caseRecordId AND Disposition__r.Group__c != null ORDER BY CreatedDate DESC LIMIT 1];
        if(!tasksToReturn.isEmpty()){
            return tasksToReturn;
        }else{
            return null;
        }
     }

    @AuraEnabled
    public static List<Case> getTicketsAtribuicao(String userId){
        return [SELECT Id, Owner.Name, Grupo_Tkt__c, CaseNumber FROM Case WHERE OwnerId =:userId AND Status != 'Resolvido'];
    }

    @AuraEnabled
    public static Boolean atribuirTickets(List<String> lstIds, String newUserId){
        List<Case> caseToUpdateList = new List<Case>();
        for(Case iLstCase : [SELECT Id, OwnerId FROM Case WHERE Id IN : lstIds]){
            iLstCase.OwnerId = newUserId;
            caseToUpdateList.add(iLstCase);
        }
        update caseToUpdateList;
        return true;
    }

}