/**
 * @description       :
 * @author            : marcelomartins@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 11-24-2021
 * @last modified by  : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-24-2021   marcelomartins@wizsolucoes.com.br   Initial Version
 **/
public with sharing class DocumentChecklistBO {
    /**
    * @description declaração de variaveis */
    private static final DocumentChecklistBO INSTANCE = new DocumentChecklistBO();

    /**
    * @description constroi a instancia da classe DocumentChecklistBO
    * @return instancia da classe DocumentChecklistBO
    */
    public static DocumentChecklistBO getInstance(){
        return INSTANCE;
    }

    /**
    * @description busca a lista de documentos ativos que constam no Checklist do objeto.
    * @param recordId
    * @return list de DocumentChecklist__c
    */
    public List<DocumentChecklist__c> getDocumentsChecklist(String recordId){
        String selecFields = 'Id, IsActive__c, DocumentRequirement__c, DocumentType__r.Name, Object__c, ObjectTypeValue__c, ObjectRecordType__c, ComplementaryParameter__c';

        return DocumentChecklistDAO.getInstance().getDocumentsChecklistByWhereCondition(selecFields, getWhereCondition(recordId));
    }


    /**
     * VERIFICAR SE O OBJETO POSSUI TODOS OS CAMPOS OBRIGATORIOS
     */
    public Boolean checkPendingMandatoryDocuments(String recordId){
        String selecFields = 'Id, IsActive__c, DocumentRequirement__c, DocumentType__r.Name, Object__c, ObjectTypeValue__c, ObjectRecordType__c, ComplementaryParameter__c';
        Map<String, Boolean> mapRequiredsFiles = new Map<String, Boolean>();
        Map<String, List<DocumentUpload__c>> mapListDocUploadForType = new Map<String, List<DocumentUpload__c>>();
        Boolean haveMandatoryDocumentsPending;

        List<DocumentChecklist__c> lstDocumentChecklist = DocumentChecklistDAO.getInstance().
                                                                getDocumentsChecklistByWhereCondition(
                                                                    selecFields,
                                                                    getWhereCondition(
                                                                        recordId
                                                                    )
                                                                );
        List<DocumentUpload__c> lstDocUpload =
            DocumentUploadDAO.getInstance().getDocumentUploadBySObjectId(recordId);


        for(DocumentChecklist__c docChecklist : lstDocumentCheckList){
            if(docChecklist.DocumentRequirement__c){
                mapRequiredsFiles.put(docChecklist.DocumentType__r.Name, true);
            }
        }

        for(DocumentUpload__c docUpload : lstDocUpload){
            if(mapRequiredsFiles.containsKey(docUpload.DocumentType__r.Name)){
                mapRequiredsFiles.remove(docUpload.DocumentType__r.Name);
            }
        }

        if(mapRequiredsFiles.isEmpty()){
            haveMandatoryDocumentsPending = false;
        }else{
            haveMandatoryDocumentsPending = true;
        }
        return haveMandatoryDocumentsPending;
    }


    /**
    * @description nota da query baseado no tipo de objeto consultado.
    * @param objectId
    * @return String constando as condições do WHERE para o DocumentChecklist
    */
    private static String getWhereCondition(String objectId){
        Map<String, Object> mapObject = new Map<String, Object>();
        String objectType = String.valueOf(Id.valueOf(objectId).getsobjecttype());
        String whereConditionChecklist = ' WHERE Object__c = \'' + objectType + '\'' + 'AND IsActive__c = true';
        String whereConditionObject = ' Where Id = \'' + objectId + '\'';
        String recordTypeDevelopName;
        String productCode;
        String typeValue;

        switch on objectType {
            when 'Account' {
                 mapObject.putAll(AccountDAO.getInstance().getAllFieldsByWhereCondition(whereConditionObject));
                 if(!mapObject.isEmpty()){
                    Account objAccount = (Account) mapObject.get(objectId);

                    recordTypeDevelopName = Schema.SObjectType.Account.getRecordTypeInfosById()
                                                        .get(
                                                            (String)(objAccount)
                                                            .get('RecordTypeId')
                                                        )
                                                        .getDeveloperName();
                }
            }

            when 'Case'{
                mapObject.putAll(CaseDAO.getInstance().getAllFieldsByWhereCondition(whereConditionObject));

                if(!mapObject.isEmpty()){
                    Case objCase = (Case) mapObject.get(objectId);

                    typeValue = (String)(objCase).get('Type');
                    recordTypeDevelopName = Schema.SObjectType.Case.getRecordTypeInfosById()
                                                        .get(
                                                            (String)(objCase)
                                                            .get('RecordTypeId')
                                                        )
                                                        .getDeveloperName();
                }
            }

            when 'Opportunity'{

                OpportunityLineItem objOppLineItem = [SELECT ProductCode FROM OpportunityLineItem WHERE OpportunityId =: objectId];

                if(objOppLineItem != null){
                    productCode = objOppLineItem.ProductCode;
                }

                mapObject.putAll(OpportunityDAO.getInstance().getAllFieldsByWhereCondition(whereConditionObject));

                if(!mapObject.isEmpty()){
                    Opportunity objOpportunity = (Opportunity) mapObject.get(objectId);

                    typeValue = (String)(objOpportunity).get('Type');
                    recordTypeDevelopName = Schema.SObjectType.Opportunity.getRecordTypeInfosById()
                                                        .get(
                                                            (String)(objOpportunity)
                                                            .get('RecordTypeId')
                                                        )
                                                        .getDeveloperName();
                }
            }

            when 'Order'{
                Product2 objProduct = [SELECT ProductCode FROM Product2 WHERE Id IN (SELECT Product2Id FROM OrderItem WHERE OrderId =: objectId)];
                if(objProduct !=null){productCode = objProduct.ProductCode;}


                mapObject.putAll(OrderDAO.getInstance().getAllFieldsByWhereCondition(whereConditionObject));

                if(!mapObject.isEmpty()){
                    Order objOrder = (Order) mapObject.get(objectId);

                    typeValue = (String)(objOrder).get('Type');
                    recordTypeDevelopName = Schema.SObjectType.Order.getRecordTypeInfosById()
                                                        .get(
                                                            (String)(objOrder)
                                                            .get('RecordTypeId')
                                                        )
                                                        .getDeveloperName();
                }
            }
            when 'Quote'{

                Product2 objProduct = [SELECT ProductCode FROM Product2 WHERE Id IN (SELECT Product2Id FROM QuoteLineItem WHERE QuoteId =: objectId)];
                if(objProduct !=null){productCode = objProduct.ProductCode;}

                mapObject.putAll(QuoteDAO.getInstance().getAllFieldsByWhereCondition(whereConditionObject));

                if(!mapObject.isEmpty()){
                    Quote objQuote = (Quote) mapObject.get(objectId);

                    typeValue = (String)(objQuote).get('Type__c');
                    recordTypeDevelopName = Schema.SObjectType.Quote.getRecordTypeInfosById()
                                                        .get(
                                                            (String)(objQuote)
                                                            .get('RecordTypeId')
                                                        )
                                                        .getDeveloperName();
                }
            }
            when 'Contract2__c'{

                mapObject.putAll(Contract2DAO.getInstance().getAllFieldsByWhereCondition(whereConditionObject));

                if(!mapObject.isEmpty()){
                    Contract2__c objContract2 = (Contract2__c) mapObject.get(objectId);

                    recordTypeDevelopName = Schema.SObjectType.Contract2__c.getRecordTypeInfosById()
                                                        .get(
                                                            (String)(objContract2)
                                                            .get('RecordTypeId')
                                                        )
                                                        .getDeveloperName();
                }
            }
        }

        if(typeValue != null){

            whereConditionChecklist += ' AND ObjectTypeValue__c = \'' + typeValue + '\'';
        }
        if(recordTypeDevelopName != null){

            whereConditionChecklist += ' AND ObjectRecordType__c = \'' + recordTypeDevelopName + '\'';
        }
        //TODO incluir após estrutura de checklist bem definida pelo time de negocial
        if(productCode != null){

            whereConditionChecklist += ' AND (ComplementaryParameter__c = \'' + productCode + '\' OR ComplementaryParameter__c = null)';
        }

        System.debug('@@@ valor da query Checklist : ' + whereConditionChecklist);

        return whereConditionChecklist;
    }

}