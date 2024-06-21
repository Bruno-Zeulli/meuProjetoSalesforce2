public without sharing class PlacementController {
    private static Integer QUANTITY_QUOTE_REQUEST;
    private static Integer QUANTITY_QUOTE_RECEIPT;
    private static Integer QUANTITY_REQUEST_INSIDE_SLA;
    private static Integer QUANTITY_REQUEST_OUTSIDE_SLA;
    private static String PRODUCT_COMBO_NAME;
    private static String MSG_PRODUCT_NOT_INFORMED = 'Produto não informado';
    private static String MSG_USER_NOT_FOUND = 'Usuário não localizado';

    @AuraEnabled(cacheable=false)
    public static String getQuoteRequests(){
        List<String> lTypeGroup = new List<String>{'Queue'};
        Map<Id, String> mapUserNameOrGroupNameByIds = UserBO.getInstance().getMapUserNameOrGroupNameByIdsAndQueues(lTypeGroup);
        List<Case> lstCasePlacement =   CaseDAO.getInstance().getCasesByOwnerId(mapUserNameOrGroupNameByIds.keySet());
        Set<Id> lstOpportunitiesIds = new Set<Id> ();
        Map<Id, List<OpportunityLineItem>> mapOpportunityLineItemByOpportunityId = new Map<Id, List<OpportunityLineItem>>();
        Map<Id, List<Quote>> mapQuoteByOpportunityId = new Map<Id, List<Quote>>();
        List<ConnectWizCMPTO.QuotesRequestsSendCMP> lstQuotesRequestsSendCMP = new List<ConnectWizCMPTO.QuotesRequestsSendCMP>();
        Set<Id> setCaseId = new Set<Id>();
        OpportunityDAO objOppDAO = new OpportunityDAO();
        Map<Id, List<DocumentUpload__c>> mapOpportunityDocuments = new Map<Id, List<DocumentUpload__c>>();
        Map<Id, String> mapOpportunityDocumentStatus = new Map<Id, String>();
        String lastModified = ' - ';

        System.debug('LISTA CASOS => ' + lstCasePlacement);

        for(Case objCase : lstCasePlacement){
            lstOpportunitiesIds.add(objCase.Opportunity__c);
            setCaseId.add(objCase.Id);
        }

        List<DocumentUpload__c> documents = [SELECT Id, IdObjeto__c, Status__c FROM DocumentUpload__c WHERE IdObjeto__c IN :lstOpportunitiesIds];
        
        for (DocumentUpload__c doc : documents) {
            if (!mapOpportunityDocuments.containsKey(doc.IdObjeto__c)) {
                mapOpportunityDocuments.put(doc.IdObjeto__c, new List<DocumentUpload__c>());
            }
            mapOpportunityDocuments.get(doc.IdObjeto__c).add(doc);
        }

        // Itera sobre o mapa de documentos e verifica o status de cada documento
        for (Id opportunityId : mapOpportunityDocuments.keySet()) {
            List<DocumentUpload__c> lstDocuments = mapOpportunityDocuments.get(opportunityId);
            String statusSummary = '';
            // Verifica se a lista de documentos está vazia
            if (lstDocuments == null || lstDocuments.isEmpty()) {
                statusSummary = 'Não foi encontrado um documento';
            } else {
                Boolean hasRefused = false;
                Boolean hasUnderReview = false;
                
                for (DocumentUpload__c doc : lstDocuments) {
                    // Verifica o status do documento
                    if (doc.Status__c == 'Refused') {
                        hasRefused = true;
                        break; // Se encontrar um documento reprovado, não precisa verificar mais
                    } else if (doc.Status__c == 'UnderReview') {
                        hasUnderReview = true;
                    }
                }
                
                // Atribui um valor à string statusSummary com base nas verificações
                if (hasRefused) {
                    statusSummary = 'utility:ban';
                } else if (hasUnderReview) {
                    statusSummary = 'utility:page';
                } else {
                    statusSummary = 'utility:check';
                }
            }
            
            // Adiciona o statusSummary ao mapa com a chave sendo o ID da oportunidade
            mapOpportunityDocumentStatus.put(opportunityId, statusSummary);
        }

        Map<Id,String> mapEnterpriseNameByOpportunity = new Map<Id,String>();
        Map<Id,String> mapComercialNameOpportunity = new Map<Id,String>();
        Map<Id,String> mapSalesUnitByOpportunity = new Map<Id,String>();

        for(Opportunity objOpp : objOppDAO.getOpportunitiesByIds(lstOpportunitiesIds)){
            mapEnterpriseNameByOpportunity.put(objOpp.Id,objOpp.EnterpriseName__c);
            mapComercialNameOpportunity.put(objOpp.Id,objOpp.OpportunityOwner__c);
            mapSalesUnitByOpportunity.put(objOpp.Id,objOpp.Owner.SalesUnit__c);
        }

        Map<Id,CaseMilestone> mapCaseMilestoneByCaseId = new Map<Id,CaseMilestone>();
        for(CaseMilestone objCaseMilestone : CaseMilestoneDAO.getCaseMilestoneByCaseId(setCaseId)){
            mapCaseMilestoneByCaseId.put(objCaseMilestone.caseId,objCaseMilestone);
        }

        for(OpportunityLineItem objOpportunityLineItem : OpportunityLineItemDAO.getOppLineItemByListOpportunityId(lstOpportunitiesIds)){

            List<OpportunityLineItem> lstOpportunityLineItem = new List<OpportunityLineItem>();

            if(mapOpportunityLineItemByOpportunityId.containsKey(objOpportunityLineItem.OpportunityId)){
                lstOpportunityLineItem = mapOpportunityLineItemByOpportunityId.get(objOpportunityLineItem.OpportunityId);
                lstOpportunityLineItem.add(objOpportunityLineItem);
                mapOpportunityLineItemByOpportunityId.put(objOpportunityLineItem.OpportunityId, lstOpportunityLineItem);
            }else{
                lstOpportunityLineItem.add(objOpportunityLineItem);
                mapOpportunityLineItemByOpportunityId.put(objOpportunityLineItem.OpportunityId, lstOpportunityLineItem);
            }

        }

        for(Quote objQuote : QuoteDAO.getInstance().getQuoteByOpportunityId(lstOpportunitiesIds)){

            List<Quote> lstQuote= new List<Quote>();

            if(mapQuoteByOpportunityId.containsKey(objQuote.OpportunityId)){
                lstQuote = mapQuoteByOpportunityId.get(objQuote.OpportunityId);
                lstQuote.add(objQuote);
                mapQuoteByOpportunityId.put(objQuote.OpportunityId, lstQuote);
            }else{
                lstQuote.add(objQuote);
                mapQuoteByOpportunityId.put(objQuote.OpportunityId, lstQuote);
            }
        }

        Set<Id> setOpportunitysAdded = new Set<Id>();
        for(Case objCase : lstCasePlacement){
            if(!setOpportunitysAdded.contains(objCase.Opportunity__c)){
                QUANTITY_QUOTE_REQUEST = 0;
                QUANTITY_QUOTE_RECEIPT = 0;
                QUANTITY_REQUEST_INSIDE_SLA = 0;
                QUANTITY_REQUEST_OUTSIDE_SLA = 0;

                ConnectWizCMPTO.QuotesRequestsSendCMP objQuotesRequestsSendCMP = new ConnectWizCMPTO.QuotesRequestsSendCMP();

                objQuotesRequestsSendCMP.caseId = objCase.Id;
                objQuotesRequestsSendCMP.ownerId = objCase.OwnerId;
                
                objQuotesRequestsSendCMP.isViolated = mapCaseMilestoneByCaseId.containsKey(objCase.Id) ? mapCaseMilestoneByCaseId.get(objCase.Id).IsViolated : null;
                mapCaseMilestoneByCaseId.remove(objCase.Id);

                objQuotesRequestsSendCMP.ownerName = mapUserNameOrGroupNameByIds.containsKey(objCase.OwnerId) ?
                                                     mapUserNameOrGroupNameByIds.get(objCase.OwnerId) :
                                                     MSG_USER_NOT_FOUND;
            
                objQuotesRequestsSendCMP.opportunityId = objCase.Opportunity__c;
                objQuotesRequestsSendCMP.opportunityOwner = objCase.OpportunityOwner__c;
                objQuotesRequestsSendCMP.opportunityNumber = objCase.Opportunity__r.OpportunityNumber__c;
                objQuotesRequestsSendCMP.accountId = objCase.AccountId;
                objQuotesRequestsSendCMP.accountName = objCase.Account.Name;
                objQuotesRequestsSendCMP.accountIdentificationNumber = objCase.Account.IdentificationNumber__c;
                objQuotesRequestsSendCMP.originCase = objCase.Origin;
                objQuotesRequestsSendCMP.leadSource = objCase.Opportunity__r.LeadSource;
                objQuotesRequestsSendCMP.statusCase = objCase.Status;
                objQuotesRequestsSendCMP.createDate = objCase.CreatedDate.date();
                objQuotesRequestsSendCMP.strCreateDate = objCase.CreatedDate.date().format();
                objQuotesRequestsSendCMP.lastModifiedName = objCase.LastModifiedDate.date().format() + lastModified + objCase.LastModifiedBy.Name;
                objQuotesRequestsSendCMP.lastModifiedDate = objCase.LastModifiedDate.date().format();
                objQuotesRequestsSendCMP.products = mapOpportunityLineItemByOpportunityId.containsKey(objCase.Opportunity__c) ?
                                                    getProductsTO(mapOpportunityLineItemByOpportunityId, objCase.Opportunity__c) :
                                                    null;
                objQuotesRequestsSendCMP.productComboName = PRODUCT_COMBO_NAME != null ?  PRODUCT_COMBO_NAME : MSG_PRODUCT_NOT_INFORMED;
                objQuotesRequestsSendCMP.quotes = mapQuoteByOpportunityId.containsKey(objCase.Opportunity__c) ?
                                                  getQuotesTO(mapQuoteByOpportunityId, mapOpportunityLineItemByOpportunityId, objCase.Opportunity__c) :
                                                  null;

                mapOpportunityLineItemByOpportunityId.remove(objCase.Opportunity__c);
            
                objQuotesRequestsSendCMP.quantityQuoteReceipt = QUANTITY_QUOTE_RECEIPT;
                objQuotesRequestsSendCMP.quantityQuoteRequest = QUANTITY_QUOTE_REQUEST;
                objQuotesRequestsSendCMP.quoteReceiptAndRequest = QUANTITY_QUOTE_RECEIPT + '/' + QUANTITY_QUOTE_REQUEST;
                objQuotesRequestsSendCMP.documentStatus = mapOpportunityDocumentStatus.get(objCase.Opportunity__c) ?? 'utility:attach';
                objQuotesRequestsSendCMP.quantityRequestInsideSLA = QUANTITY_REQUEST_INSIDE_SLA;
                objQuotesRequestsSendCMP.quantityRequestOutsideSLA = QUANTITY_REQUEST_OUTSIDE_SLA;

                objQuotesRequestsSendCMP.enterpriseName = mapEnterpriseNameByOpportunity.get(objCase.Opportunity__c);
                mapEnterpriseNameByOpportunity.remove(objCase.Opportunity__c);

                objQuotesRequestsSendCMP.comercialName = mapComercialNameOpportunity.get(objCase.Opportunity__c);
                mapComercialNameOpportunity.remove(objCase.Opportunity__c);

                objQuotesRequestsSendCMP.salesUnit = mapSalesUnitByOpportunity.get(objCase.Opportunity__c);
                mapSalesUnitByOpportunity.remove(objCase.Opportunity__c);

                setOpportunitysAdded.add(objCase.Opportunity__c);
                lstQuotesRequestsSendCMP.add(objQuotesRequestsSendCMP);
            }
        }

        System.debug('Imprimiu => ' + JSON.serialize(lstQuotesRequestsSendCMP));

        return JSON.serialize(lstQuotesRequestsSendCMP);
    }

    @AuraEnabled(cacheable=false)
    public static Boolean updateOwnerCaseFromPlacement(String caseId, String userId, String status){
         try{
            Case objCase = new Case(
                Id = caseId,
                OwnerId = userId,
                Status = status
            );

            Database.SaveResult srUpdCase= Database.update(objCase, false);
            if(srUpdCase.isSuccess()){
                System.debug('Successfully updated owner case. case id: ' + srUpdCase.getId());
                return srUpdCase.isSuccess();
            }else{
                System.debug('Failed to update owner case error message: ' + srUpdCase.getErrors());
                return false;
            }
        } catch (Exception e){
            System.debug('Failed to update owner case error message: ' + e.getMessage());
            return false;
        }
    }

    @AuraEnabled(cacheable=false)
    public static Boolean updateOwnerCaseFromPlacementHeader(String caseId, String userId){
         try{
            Case objCase = new Case(
                Id = caseId,
                OwnerId = userId
            );

            Database.SaveResult srUpdCase= Database.update(objCase, false);
            if(srUpdCase.isSuccess()){
                return srUpdCase.isSuccess();
            }else{
                return false;
            }
        } catch (Exception e){
            System.debug('Failed to update owner case error message: ' + e.getMessage());
            return false;
        }
    }

    private static List<ConnectWizCMPTO.Product> getProductsTO(Map<Id, List<OpportunityLineItem>> mapOpportunityLineItemByOpportunityId, String opportunityId){
        List<ConnectWizCMPTO.Product> lProducts = new List<ConnectWizCMPTO.Product>();
        String srtProductName = null;
        PRODUCT_COMBO_NAME = null;

        for(OpportunityLineItem objOpportunityLineItem : mapOpportunityLineItemByOpportunityId.get(opportunityId)){

            ConnectWizCMPTO.Product productTO = new ConnectWizCMPTO.Product();
            productTO.productFamily = objOpportunityLineItem.Product2.Family;
            productTO.productId = objOpportunityLineItem.Product2Id;
            productTO.productName = objOpportunityLineItem.Product2.Name;
            lProducts.add(productTO);
            if(srtProductName == null){
                srtProductName = objOpportunityLineItem.Product2.Name;
            }else if(!srtProductName.contains(objOpportunityLineItem.Product2.Name)){
                srtProductName = srtProductName + ' + ' + objOpportunityLineItem.Product2.Name;
            }
        }

        PRODUCT_COMBO_NAME = srtProductName;

        return lProducts;
    }

    private static List<ConnectWizCMPTO.Quote> getQuotesTO(
        Map<Id, List<Quote>> mapQuoteByOpportunityId,
        Map<Id, List<OpportunityLineItem>> mapOpportunityLineItemByOpportunityId,
        String opportunityId
    ){
        List<ConnectWizCMPTO.Quote> lQuotes = new List<ConnectWizCMPTO.Quote>();
        /*List<String> lSrtQuoteRequest = new List<String>();
        List<String> lSrtQuoteReceipt = new List<String>();
        List<String> lSrtRequestInsideSLA = new List<String>();
        List<String> lSrtRequestOutsideSLA  = new List<String>(); */
        Integer referenceSLA = 0;

        List<OpportunityLineItem> lstOpportunityLineItem = mapOpportunityLineItemByOpportunityId.containsKey(opportunityId) ?
                                                            mapOpportunityLineItemByOpportunityId.get(opportunityId) :
                                                            null;
        Integer quoteReturnSLA = lstOpportunityLineItem.size() > 0 ?
                                    Integer.valueOf(lstOpportunityLineItem[0].Product2.QuoteReturnSLA__c) :
                                    null;

        for(Quote objQuote : mapQuoteByOpportunityId.get(opportunityId)){

            ConnectWizCMPTO.Quote quoteTO = new ConnectWizCMPTO.Quote();
                quoteTO.insuranceCompany = objQuote.Company__c;
                quoteTO.quoteReceiptDate = objQuote.QuoteReceiptDate__c;
                quoteTO.quoteRequestDate = objQuote.QuoteRequestDate__c;
            lQuotes.add(quoteTO);

            if(objQuote.QuoteReceiptDate__c != null){
                QUANTITY_QUOTE_RECEIPT++;
            }
            else if(objQuote.QuoteRequestDate__c != null){
                QUANTITY_QUOTE_REQUEST++;
                referenceSLA =  objQuote.QuoteReceiptDate__c != null ?
                                objQuote.QuoteRequestDate__c.daysBetween(objQuote.QuoteReceiptDate__c) :
                                objQuote.QuoteRequestDate__c.daysBetween(date.today());
            }

            if(quoteReturnSLA != null){
                if(quoteReturnSLA >= referenceSLA){
                    QUANTITY_REQUEST_INSIDE_SLA++;
                }else{
                    QUANTITY_REQUEST_OUTSIDE_SLA++;
                }
            }else{
                QUANTITY_REQUEST_INSIDE_SLA++;
            }


        }

        // QUANTITY_REQUEST_INSIDE_SLA
        // QUANTITY_REQUEST_OUTSIDE_SLA
        // QUANTITY_QUOTE_REQUEST = StringUtil.getInstance().getSizeListString(lSrtQuoteRequest);
        // QUANTITY_QUOTE_RECEIPT = StringUtil.getInstance().getSizeListString(lSrtQuoteReceipt);

        return lQuotes;
    }

    @AuraEnabled
    public static Task createTaskHistory(String whatId, String whoId, String subject, String description, String type){
         try{
            Task task = new Task(
                Subject = subject,
                OwnerId = UserInfo.getUserId(),
                Status = 'Open',
                Priority = 'Normal',
                Description = description,
                Type = type,
                WhatId = whatId,
                WhoId = whoId,
                RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Connect@Wiz').getRecordTypeId(),
                BusinessUnit__c = 'CORPORATE',
                IsVisibleInSelfService = true
            );
            TaskBO.getInstance().createTaskHistory(
                whatId,
                whoId,
                subject,
                description,
                type,
                task.RecordTypeId,
                task.BusinessUnit__c
            );
            return task;
        } catch(Exception e){
            System.debug(e.getMessage());
        }
        return null;
    }


    @AuraEnabled
    public static Boolean updateCaseFromPlacement(String caseId, String reason, String status){
        Boolean resp= false;
         try{
            Case objCase = new Case(
                Id = caseId,
                Status = status,
                Reason = reason
            );

            Database.SaveResult srUpdCase = Database.update(objCase, false);
            if(srUpdCase.isSuccess()){
                resp = true;
                System.debug('Successfully updated case. case id: ' + srUpdCase.getId());
                return resp;
            }else{
                System.debug('Failed to update case error message: ' + srUpdCase.getErrors());
                return false;
            }
        } catch (Exception e){
            System.debug('Failed to update error message: ' + e.getMessage());
            return false;
        }
    }


    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getUserQueueInfo(String userId) {
        List<Map<String, String>> queueInfoList = new List<Map<String, String>>();
        
        // Consulta SOQL para recuperar o nome e o ID da fila atribuída a um usuário
        List<Group> groups = [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND Id IN (SELECT GroupId FROM GroupMember WHERE UserOrGroupId = :userId)];

        // Verifica se a lista de filas não está vazia
        if (!groups.isEmpty()) {
            for (Group g : groups) {
                // Acessando o nome da fila e o ID
                String filaNome = g.Name;
                String filaId = g.Id;
                
                // Adicionando informações da fila ao mapa
                Map<String, String> queueInfo = new Map<String, String>();
                queueInfo.put('NomeFila', filaNome);
                queueInfo.put('IdFila', filaId);
                
                // Adicionando o mapa à lista de informações da fila
                queueInfoList.add(queueInfo);
            }
        } else {
            // Se o usuário não estiver atribuído a nenhuma fila, você pode lidar com isso aqui
            System.debug('O usuário não está atribuído a nenhuma fila.');
        }
        
        return queueInfoList;
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, List<Map<String, String>>> getUsersFromQueue(List<Id> lstQueueId) {
        Map<String, List<Map<String, String>>> queueUserMap = new Map<String, List<Map<String, String>>>();
        
        // Consulta para buscar os nomes das filas
        List<Group> queues = [SELECT Id, Name FROM Group WHERE Id IN :lstQueueId];
        
        // Itera sobre as filas para buscar os membros e extrair os IDs dos usuários
        for (Group queue : queues) {
            List<GroupMember> queueMembers = [SELECT UserOrGroupId FROM GroupMember WHERE GroupId = :queue.Id];
            Set<Id> userIds = new Set<Id>();
            for (GroupMember member : queueMembers) {
                userIds.add((Id)member.UserOrGroupId);
            }
            
            // Consulta para buscar os nomes dos usuários com base nos IDs coletados
            List<User> users = [SELECT Id, Name FROM User WHERE Id IN :userIds];
            
            // Cria uma lista de mapas com informações dos usuários
            List<Map<String, String>> userList = new List<Map<String, String>>();
            for (User user : users) {
                Map<String, String> userInfo = new Map<String, String>();
                userInfo.put('userId', user.Id);
                userInfo.put('userName', user.Name);
                userList.add(userInfo);
            }
            
            // Adiciona a lista de usuários ao mapa com o nome da fila como chave
            queueUserMap.put(queue.Name, userList);
        }
        
        return queueUserMap;
    }

    @AuraEnabled(cacheable=false)
    public static Map<String, Object> getInfoForHeader(String caseId, String oppId) {
        // Substitua os campos desejados pelos campos que você precisa
        Case caseRecord = [SELECT Owner.Name, Account.Name, ContactId, Account.CompanyIdentificationNumber__c, Status FROM Case WHERE Id = :caseId LIMIT 1];
        Opportunity oppRecord = [SELECT OpportunityNumber__c, RecordType.Name, (SELECT Product2.Name FROM OpportunityLineItems) FROM Opportunity WHERE Id = :oppId LIMIT 1];
        
        Map<String, Object> caseInfo = new Map<String, Object>();
        caseInfo.put('OwnerName', caseRecord.Owner.Name);
        caseInfo.put('AccountName', caseRecord.Account.Name);
        caseInfo.put('Status', caseRecord.Status);
        caseInfo.put('ContactId', caseRecord.ContactId);
        caseInfo.put('CompanyIdentificationNumber', caseRecord.Account.CompanyIdentificationNumber__c);
        caseInfo.put('OpportunityNumber', oppRecord.OpportunityNumber__c);
        caseInfo.put('OpportunityRecordTypeName', oppRecord.RecordType.Name);

        // Adicionar o nome do produto se houver um OpportunityLineItem associado
        if (!oppRecord.OpportunityLineItems.isEmpty()) {
            caseInfo.put('ProductName', oppRecord.OpportunityLineItems[0].Product2.Name);
        }
    
        return caseInfo;
    }

    @AuraEnabled(cacheable=true)
    public static String postInChatter(String oppId, String observation){
        try {
            // Chama o método @future
            postInChatterAsync(oppId, observation);
            
            return 'Post efetuado!';
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
        }
        
        return 'Post não efetuado';
    }

    @future(callout=true)
    public static void postInChatterAsync(String oppId, String observation) {
        FeedItem post = new FeedItem();
        post.Body = observation;
        post.ParentId = oppId;
        post.Title = 'Comentário';
        post.Type = 'TextPost';
        insert post;
    }

    @AuraEnabled
    public static String getCaseHistoryByIds(Id caseId, Id opportunityId) {

        List<Map<String, Object>> caseInfoList = new List<Map<String, Object>>();
        
        List<CaseHistory> caseHistories = [SELECT Id, Field, OldValue, NewValue, CreatedDate, CreatedById, CreatedBy.Name, DataType
                                            FROM CaseHistory 
                                            WHERE CaseId = :caseId 
                                            ORDER BY CreatedDate DESC];
        
        List<Task> relatedTasks = [SELECT Id, Subject, Description, LastModifiedDate, LastModifiedBy.Name, Type
                                   FROM Task 
                                   WHERE WhatId = :opportunityId 
                                   ORDER BY CreatedDate DESC];

        List<FeedItem> commentsChatter = [SELECT Id, CreatedBy.Name, Body, CreatedDate
                                    FROM FeedItem 
                                    WHERE ParentId = :opportunityId
                                    AND Id != null
                                    AND Type = 'TextPost'];
        
        for (CaseHistory history : caseHistories) {
            Map<String, Object> historyInfo = new Map<String, Object>();
            historyInfo.put('id', history.Id);
            String formattedDate = history.CreatedDate.format('hh:mm a | dd/MM/yyyy');
            if (history.Field == 'Owner' && history.DataType == 'Text') {
                historyInfo.put('subject', 'Oportunidade atribuída');
                historyInfo.put('description', 'De: ' + history.OldValue + ', Para: ' + history.NewValue);
                historyInfo.put('personName', history.CreatedBy.Name);
                historyInfo.put('dateTimeValue', formattedDate);
                historyInfo.put('dateTimeValueOrigin', history.CreatedDate);
                caseInfoList.add(historyInfo);
                
            }else if (history.Field == 'Status') {
                historyInfo.put('subject', 'Atualização de Status - ' + history.NewValue);
                historyInfo.put('description', 'Status anterior: ' + history.OldValue);
                historyInfo.put('personName', history.CreatedBy.Name);
                historyInfo.put('dateTimeValue', formattedDate);
                historyInfo.put('dateTimeValueOrigin', history.CreatedDate);
                caseInfoList.add(historyInfo);
            }
            continue;
        }
        
        for (Task task : relatedTasks) {
            Map<String, Object> taskInfo = new Map<String, Object>();
            String formattedDate = task.LastModifiedDate.format('hh:mm a | dd/MM/yyyy');
            if(String.isEmpty(task.Type)){
                continue;
            }
            taskInfo.put('id', task.Id);
            taskInfo.put('subject', 'Tarefa - ' + task.Subject);
            taskInfo.put('description', 'Descrição: ' + (task.Description ?? 'Sem descrição da tarefa'));
            taskInfo.put('personName', task.LastModifiedBy.Name);
            taskInfo.put('dateTimeValue', formattedDate);
            taskInfo.put('dateTimeValueOrigin', task.LastModifiedDate);
            caseInfoList.add(taskInfo);
        }
        
        for(FeedItem comment : commentsChatter) {
            Map<String, Object> commentInfo = new Map<String, Object>();
            String formattedDate = comment.CreatedDate.format('hh:mm a | dd/MM/yyyy');
            commentInfo.put('id', comment.id);
            commentInfo.put('subject', 'Comentário');
            commentInfo.put('description', 'Descrição: ' + comment.Body);
            commentInfo.put('personName', comment.CreatedBy.Name);
            commentInfo.put('dateTimeValue', formattedDate);
            commentInfo.put('dateTimeValueOrigin', comment.CreatedDate);
            caseInfoList.add(commentInfo);
        }
        
        String jsonResult = JSON.serializePretty(caseInfoList);
        return jsonResult;

    }

    @AuraEnabled(cacheable=true)
    public static Map<String, String> getUserInfos(String userId){
        Map<String, String> userDetails = new Map<String, String>();
        User userInfo = [SELECT FirstName, LastName, UserRole.Name FROM User WHERE Id = :userId LIMIT 1];
        String initials = (userInfo.FirstName != null && userInfo.FirstName.length() > 0) ? userInfo.FirstName.substring(0, 1).toUpperCase() : '';
        initials += (userInfo.LastName != null && userInfo.LastName.length() > 0) ? userInfo.LastName.substring(0, 1).toUpperCase() : '';
        userDetails.put('Initials', initials);
        userDetails.put('Name', userInfo.FirstName + ' ' + userInfo.LastName);
        userDetails.put('Function', userInfo.UserRole.Name);

        return userDetails;
    }

    @AuraEnabled(cacheable=true)
    public static String logoutUser() {
        return URL.getOrgDomainURL().toExternalForm() + '/secur/logout.jsp';
    }
}