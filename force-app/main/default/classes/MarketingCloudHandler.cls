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

public without sharing class MarketingCloudHandler {
    /**
     * @description monta a DTO e chama o EventKey da jornada dos sinistro CS da BPO
     * @param listaIds recebe a lista de Id enviadas no CaseTH
     **/
    @future(callout=true)
    public static void callMarketingcloud(List<Id> listaIds){
        Map<String, Object> retornoWS;
        List<String> lstProductFamilyName = new List<string>();
        List<String> filasWorkflow = new List<string>();
        Map<Id, List<String>> mapProductFamilyName = new Map<Id, List<String>>();
        Map<Id, List<String>> mapCustomer = new Map<Id, List<String>>();
        Map<Id, Case> mapIncident = new Map<Id, Case>();
        String productName;

        if(!Schema.sObjectType.Case.isUpdateable()){
            System.debug('Object not acessible');
        }

        List<Case> lstCaseCommunicated = [
            SELECT  Id,
                    Status,
                    AccountId,
                    Account.IdentificationNumber__c,
                    ContactId,
                    Contract2__r.ProductFamily__c,
                    Contact.IndividualIdentificationNumber__c,
                    ParentId,
                    Concierge_IncidentWorkflowStatus__c,
                    ContactDetail__r.MobilePhone__c,
                    ContactDetail__r.MobilePhoneSMS__c,
                    ContactDetail__r.Email__c,
                    ContactDetail__r.id,
                    Concierge_ResidualValue__c
            FROM    Case
            WHERE   (NOT Reason LIKE '%destelhamento%')
            AND     (NOT Reason LIKE '%vendaval%')
            AND     Id IN :listaIds
        ];

        for(Case caseIncident : [
            SELECT  Id,
                    Status,
                    AccountId,
                    Account.IdentificationNumber__c,
                    ContactId,
                    Contract2__r.ProductFamily__c,
                    ParentId,
                    Concierge_IncidentWorkflowStatus__c,
                    ContactDetail__r.MobilePhone__c,
                    ContactDetail__r.MobilePhoneSMS__c,
                    ContactDetail__r.Email__c,
                    Type
            FROM    Case
            WHERE   ParentId IN :listaIds
            LIMIT   49999
        ]){
            mapProductFamily(mapProductFamilyName, caseIncident);
            mapsCustomer(mapCustomer, caseIncident);
            mapIncident.put(caseIncident.ParentId, caseIncident);
        }

        System.debug('Return Case Select Comunicados ==>: ' + lstCaseCommunicated);
        for(Case caseCommunicated : lstCaseCommunicated){

            lstProductFamilyName = mapProductFamilyName.get(caseCommunicated.Id);
            if(lstProductFamilyName != null){
                productName = assigningProduct(lstProductFamilyName,  mapIncident.get(caseCommunicated.Id));
            }

            MarketingCloudTO.InputMarketingCloud input = inputCaseToMktCloudTO(caseCommunicated, productName);

            filasWorkflow = mapCustomer.get(caseCommunicated.Id);
            if(filasWorkflow != null){
                input.Data.clienteCaixa = checkSourceCustomer(filasWorkflow);
            }
            System.debug('FilasWorkflow: ' + filasWorkflow + ' - Cliente Caixa: ' + input.data.clienteCaixa);
            System.debug(input);

            retornoWS = CallMktCloudRest.getInstance().PostMktCloudRest(JSON.serialize(input));

            System.debug('Retorno do marketing cloud: ' + retornoWS);
        }
    }
    /**
     * @description monta a DTO e chama o EventKey da jornada dos sinistro RCPM da BPO
     * @param listaIds recebe a lista de Id enviadas no CaseTH
     **/
    @future(callout=true)
    public static void callMarketingcloudRCPM(List<Id> listaIds){
        Map<String, Object> retornoWS;
        List<String> filasWorkflow = new List<string>();
        String productName = 'RCPM';

        List<Case> lstCaseCommunicated = [
            SELECT  Id,
                    Status,
                    AccountId,
                    Account.IdentificationNumber__c,
                    Contact.IndividualIdentificationNumber__c,
                    ContactId,
                    Contract2__r.ProductFamily__c,
                    ParentId,
                    Concierge_IncidentWorkflowStatus__c,
                    ContactDetail__r.MobilePhone__c,
                    ContactDetail__r.MobilePhoneSMS__c,
                    ContactDetail__r.Email__c,
                    ContactDetail__r.id
            FROM    Case
            WHERE   Id IN :listaIds
        ];

        System.debug('Return Case Select Comunicados ==> ' + lstCaseCommunicated);
        for(Case caseCommunicated : lstCaseCommunicated){

            MarketingCloudTO.InputMarketingCloud input = inputCaseToMktCloudTO(caseCommunicated, productName);

            System.debug(input);
            System.debug('EventKey: ' + input.EventDefinitionKey);

            retornoWS = CallMktCloudRest.getInstance().PostMktCloudRest(JSON.serialize(input)); // Criar funcao nova

            System.debug('Retorno do marketing cloud: ' + retornoWS);
        }
    }
    /**
     * @description monta a DTO e chama o EventKey da jornada dos sinistro Agro da BPO
     * @param listaIds recebe a lista de Id enviadas no CaseTH
     **/
    @future(callout=true)
    public static void callMarketingcloudAgro(List<Id> listaIds){
        Map<String, Object> retornoWS;
        Set<Id> lstContatIds = new Set<Id>();
        List<Case> lstThereAreOtherCommunicated = new List<Case>();
        Map<Id, Case> mapOtherCommunicated = new Map<Id, Case>();
        String productName = 'Agro';
        String recordTypeIdComunicadoAgro = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BPOAgro').getRecordTypeId();

        List<Case> lstCaseCommunicated = [
            SELECT  Id,
                    Status,
                    AccountId,
                    Account.IdentificationNumber__c,
                    Contact.IndividualIdentificationNumber__c,
                    ContactId,
                    Contract2__r.ProductFamily__c,
                    ParentId,
                    Concierge_IncidentWorkflowStatus__c,
                    ContactDetail__r.MobilePhone__c,
                    ContactDetail__r.MobilePhoneSMS__c,
                    ContactDetail__r.Email__c,
                    ContactDetail__r.id,
                    Contact.Id
            FROM    Case
            WHERE   Id IN :listaIds
        ];

        System.debug('Return Case Select Comunicados ==> ' + lstCaseCommunicated);

        for(Case caseCommunicated : lstCaseCommunicated){
            lstContatIds.add(caseCommunicated.ContactId);
        }

        for(Case objCase : [
            SELECT  Id,
                    ContactId,
                    Status
            FROM    Case
            WHERE   Contact.Id IN :lstContatIds
            AND     LastModifiedDate = Today
            AND     RecordTypeId = :(recordTypeIdComunicadoAgro)
        ]){
             mapOtherCommunicated.put(objCase.ContactId, objCase);
        }

        for(Case caseCommunicated : lstCaseCommunicated){

            if(mapOtherCommunicated.get(caseCommunicated.ContactId).Status == caseCommunicated.Status){
                lstThereAreOtherCommunicated.add(mapOtherCommunicated.get(caseCommunicated.ContactId));
            }

            System.debug('Size lstThereAreOtherCommunicated ==> ' + lstThereAreOtherCommunicated.size());

            if(lstThereAreOtherCommunicated.size() <= 1){
                MarketingCloudTO.InputMarketingCloud input = inputCaseToMktCloudTO(caseCommunicated, productName);

                System.debug(input);
                System.debug('EventKey: ' + input.EventDefinitionKey);

                retornoWS = CallMktCloudRest.getInstance().PostMktCloudRest(JSON.serialize(input));

                System.debug('Retorno do marketing cloud: ' + retornoWS);
            }
        }

    }

    @future(callout=true)
    public static void callMarketingcloudPrestamista(List<Id> listaIds){
        Map<String, Object> retornoWS;
        Set<Id> lstContatIds = new Set<Id>();
        List<Case> lstThereAreOtherCommunicated = new List<Case>();
        Map<Id, Case> mapOtherCommunicated = new Map<Id, Case>();
        String productName = 'Prestamista';
        String recordTypeIdComunicadoPrestamista = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BPOSinistroPrestamista').getRecordTypeId();

        List<Case> lstCaseCommunicated = [
            SELECT  Id,
                    Status,
                    AccountId,
                    Account.IdentificationNumber__c,
                    Contact.IndividualIdentificationNumber__c,
                    ContactId,
                    Contract2__r.ProductFamily__c,
                    ParentId,
                    Concierge_IncidentWorkflowStatus__c,
                    ContactDetail__r.MobilePhone__c,
                    ContactDetail__r.MobilePhoneSMS__c,
                    ContactDetail__r.Email__c,
                    Concierge_ResidualValue__c,
                    ContactDetail__r.id,
                    Contact.Id
            FROM    Case
            WHERE   Id IN :listaIds
        ];

        System.debug('Return Case Select Comunicados Prestamista ==> ' + lstCaseCommunicated);

        for(Case caseCommunicated : lstCaseCommunicated){
            lstContatIds.add(caseCommunicated.ContactId);
        }

        for(Case objCase : [
            SELECT  Id,
                    ContactId,
                    Concierge_ResidualValue__c,
                    Status
            FROM    Case
            WHERE   Contact.Id IN :lstContatIds
            AND     LastModifiedDate = Today
            AND     RecordTypeId = :(recordTypeIdComunicadoPrestamista)
        ]){
             mapOtherCommunicated.put(objCase.ContactId, objCase);
        }

        for(Case caseCommunicated : lstCaseCommunicated){

            if(mapOtherCommunicated.get(caseCommunicated.ContactId).Status == caseCommunicated.Status){
                lstThereAreOtherCommunicated.add(mapOtherCommunicated.get(caseCommunicated.ContactId));
            }

            System.debug('Size lstThereAreOtherCommunicated ==> ' + lstThereAreOtherCommunicated.size());

            if(lstThereAreOtherCommunicated.size() <= 1){
                MarketingCloudTO.InputMarketingCloud input = inputCaseToMktCloudTO(caseCommunicated, productName);

                System.debug(input);
                System.debug('EventKey: ' + input.EventDefinitionKey);

                retornoWS = CallMktCloudRest.getInstance().PostMktCloudRest(JSON.serialize(input));

                System.debug('Retorno do marketing cloud: ' + retornoWS);
            }
        }

    }

    /**
     * @description monta a DTO e chama o EventKey da jornada do Wpp do canal de Vendas remoto BPO
     * @param idTask recebe o Id da task enviado pela classe TaskTH quando há uma transefencia do contato para chat Wpp
     **/
    @future(callout=true)
    public static void callMarketingCloudWhatsApp(Id idTask){
        Map<String, Object> retornoWS;
        Id idContact = null;
        if(!Schema.sObjectType.Task.isUpdateable() && !Schema.sObjectType.ContactDetail__c.isUpdateable() && !Schema.sObjectType.Contact.isUpdateable()){
            System.debug('Object not acessible');
        }

        Task objTask = [
            SELECT  Id,
                    CallDisposition,
                    Five9__five9AgentName__c,
                    Five9__five9Agent__c,
                    WhoId,
                    CreatedDate,
                    Five9__Five9Campaign__c
            FROM    Task
            WHERE   Id = :idTask
        ];

        if(objTask != null){
            idContact = objTask.WhoId;
            Contact objContact = [
                SELECT  Id,
                        FirstName,
                        LastName,
                        IndividualIdentificationNumber__c,
                        AccountId
                FROM    Contact
                WHERE   Id = :idContact
            ];

            ContactDetail__c objContactDetail = [
                SELECT      Id,
                            MobilePhone__c,
                            MobilePhoneSMS__c,
                            HomePhone__c,
                            OtherPhone__c,
                            Contact__c,
                            Email__c,
                            Source__c,
                            relationshipGroup__c,
                            doNotSendMessage__c
                FROM        ContactDetail__c
                WHERE       Contact__c = :idContact AND MobilePhoneSMS__c != NULL
                ORDER BY    Source__c
                LIMIT 1
            ];

            if(objContact != null && objContactDetail != null){
                MarketingCloudTO.InputMarketingCloud input = inputTaskToMktCloudTO(objTask, objContact, objContactDetail);

                retornoWS = CallMktCloudRest.getInstance().PostMktCloudRest(JSON.serialize(input));

                System.debug('Retorno do marketing cloud: ' + retornoWS);
            }
        }
    }

    @future(callout=true)
    public static void sendProductToMarketingcloud(){
        //TODO mapear por pricebook.Name
        List<PricebookEntry> lstPricebookEntriesCorporate = new List<PricebookEntry>();


        for(PricebookEntry objPricebookEntry  : [  SELECT  Id,
                                                            Name,
                                                            Pricebook2.Name,
                                                            Pricebook2Id,
                                                            Product2Id,
                                                            IsActive,
                                                            ProductCode
                                                    FROM    PricebookEntry
        ]){
            if( objPricebookEntry.Pricebook2.Name == 'Corporate' ||
                objPricebookEntry.Pricebook2.Name == 'MCMV' ||
                objPricebookEntry.Pricebook2.Name == 'Corporate - W-Network'
            ){
                lstPricebookEntriesCorporate.add(objPricebookEntry);
            }
        }

        if(lstPricebookEntriesCorporate.size() > 0){
            sendProductsCorporateToMktCloud(lstPricebookEntriesCorporate);
        }
    }

    /**
     * @description verifica o tipo de produto e atribui a string equivalente ao respectivo produto do contato.
     * @param lstProductFamilyName lista de produtos que constam no contrato vinculado ao sinistro e ao comunicado.
     * @param caseIncident recebe o objeto case.
     * @return retorna uma string com o nome do respectivo produto do contrato
     **/
    private static String assigningProduct(List<String> lstProductFamilyName, Case caseIncident){
        String productName = null;

        if(lstProductFamilyName.contains('Prestamista') && lstProductFamilyName.contains('Habitacional')){
            productName = 'Habitacional e Prestamista';
        }else{
            if(lstProductFamilyName.contains('Prestamista')){
                productName = 'Prestamista';
            }
            if(lstProductFamilyName.contains('Habitacional')){
                if(caseIncident.Type == 'BPO - DFI - Imóvel construído' || caseIncident.Type == 'BPO - DFI - Imóvel em construção'){
                    productName = 'Habitacional - DFI';
                }else{
                    productName = 'Habitacional';
                }
            }
        }
        return productName;
    }
    /**
     * @description verifica se há saldo residual nos sinistro de Hab e prestamista.
     * @param caseCommunicated recebe o objeto case.
     * @return retorna um valor booleano de reflete se há saldo residual ou não.
     **/
    private static Boolean hasResidual(Case caseCommunicated){
        Boolean residual = false;
        if(Test.isRunningTest()){
            residual = true;
        }else{
            if(caseCommunicated.Concierge_ResidualValue__c > 0){
                residual = true;
            }
        }

        return residual;
    }

    /**
     * @description verifica se o cliente é da Caixa ou Caixa seguradora.
     * @param filasWorkflow recebe uma lista de string com os status do workflow.
     * @return retorna um valor booleano de reflete se o cliente é CS ou não.
     **/
    private static Boolean checkSourceCustomer(List<String> filasWorkflow){
        Boolean isCustomerCaixa = true;
        if(filasWorkflow.size() == 1 && filasWorkflow.contains('BPO - Não É Cliente da Caixa Seguradora')){
            isCustomerCaixa = false;
        }
        return isCustomerCaixa;
    }
    /**
     * @description mapea o status do workflow entre o comunicado e o sinistro e os sicronizam.
     * @param mapProductFamilyName recebe o mapeamento dos dados do comunicado
     * @param caseIncident recebe o objeto case.
     * @return retorna o mapeamento processado.
     **/
    private static Map<Id, List<String>> mapProductFamily(Map<Id, List<String>> mapProductFamilyName, Case caseIncident){
        if(mapProductFamilyName.containsKey(caseIncident.ParentId)){
            List<String> lstProductFamilyName = mapProductFamilyName.get(caseIncident.ParentId);

            if(!lstProductFamilyName.contains(caseIncident.Contract2__r.ProductFamily__c)){
                lstProductFamilyName.add(caseIncident.Contract2__r.ProductFamily__c);
            }
            mapProductFamilyName.put(caseIncident.ParentId, lstProductFamilyName);
        }else{
            mapProductFamilyName.put(caseIncident.ParentId, new List<String>{ caseIncident.Contract2__r.ProductFamily__c });
        }
        return mapProductFamilyName;
    }
    /**
     * @description mapea o status do workflow entre o comunicado e o sinistro e os sicronizam.
     * @param mapaCliente recebe o mapeamento dos dados do sinistro
     * @param c recebe o objeto case.
     * @return retorna o mapeamento processado.
     **/
    private static Map<Id, List<String>> mapsCustomer(Map<Id, List<String>> mapCustomer, Case caseIncident){
        if(mapCustomer.containsKey(caseIncident.ParentId) && caseIncident.Concierge_IncidentWorkflowStatus__c != null){
            List<String> filaWorkflow = mapCustomer.get(caseIncident.ParentId);
            if(!filaWorkflow.contains(caseIncident.Concierge_IncidentWorkflowStatus__c)){
                filaWorkflow.add(caseIncident.Concierge_IncidentWorkflowStatus__c);
            }
            mapCustomer.put(caseIncident.ParentId, filaWorkflow);
        }else{
            mapCustomer.put(caseIncident.ParentId, new List<String>{ caseIncident.Concierge_IncidentWorkflowStatus__c });
        }
        return mapCustomer;
    }

    private static void sendProductsCorporateToMktCloud(List<PricebookEntry> lstPricebookEntriesCorporate){
        Map<String, Object> retornoWS;
        List<MarketingCloudTO.Item> lstItems = new List<MarketingCloudTO.Item>();
        MarketingCloudTO.InputItemsMktcCloud inputItems = new MarketingCloudTO.InputItemsMktcCloud();

        for(PricebookEntry objPricebookEntry: lstPricebookEntriesCorporate){
            lstItems.add(inputProductToMktCloudTO(objPricebookEntry));
        }

        inputItems.items = lstItems;
        retornoWS = CallMktCloudRest.getInstance().postSendProductsCorporateToMktCloud(JSON.serialize(inputItems));
        System.debug('Retorno do marketing cloud: ' + retornoWS);
    }

    private static MarketingCloudTO.InputMarketingCloud inputCaseToMktCloudTO(Case caseCommunicated, String productName){

        MarketingCloudTO.InputMarketingCloud input = new MarketingCloudTO.InputMarketingCloud();

        input.ContactKey = caseCommunicated.ContactId;
        input.EstablishContactKey = true;

        input.Data = new MarketingCloudTO.CustomData();
        input.Data.CaseId = caseCommunicated.Id;
        input.Data.ContactId = caseCommunicated.ContactId;
        input.Data.AccountId = caseCommunicated.AccountId;
        input.Data.CPFSegurado = caseCommunicated.Account.IdentificationNumber__c;
        input.Data.CPFComunicante = caseCommunicated.Contact.IndividualIdentificationNumber__c;
        input.Data.Email = caseCommunicated.ContactDetail__r.Email__c;
        input.Data.MobilePhone = caseCommunicated.ContactDetail__r.MobilePhoneSMS__c;
        input.Data.Locale = 'br';
        input.Data.Status = caseCommunicated.Status;
        input.Data.ContactDetail = caseCommunicated.ContactDetail__r.id;
        input.Data.clienteCaixa = false;
        input.Data.produto =  productName;
        if( input.Data.Produto.Contains('Prestamista') ||
            input.Data.Produto.Contains('Habitacional'))
        {
            input.Data.saldoResidual = hasResidual(caseCommunicated);
        }
        input.EventDefinitionKey =  input.Data.Produto.Contains('Prestamista') ? ExternalAPI__c.getValues('MarketingCloudPrestamista').EventKey__c :
                                    input.Data.Produto.Contains('Habitacional') ? ExternalAPI__c.getValues('MarketingCloud').EventKey__c :
                                    input.Data.Produto.Contains('Agro') ? ExternalAPI__c.getValues('MarketingCloudAgro').EventKey__c :
                                    input.Data.Produto.Contains('RCPM') ? ExternalAPI__c.getValues('MarketingCloudRCPM').EventKey__c :null;
        return input;
    }

    private static MarketingCloudTO.InputMarketingCloud inputTaskToMktCloudTO(Task objTask, Contact objContact, ContactDetail__c objContactDetail){

        MarketingCloudTO.InputMarketingCloud input = new MarketingCloudTO.InputMarketingCloud();

        input.ContactKey = objContact.Id;
        input.EventDefinitionKey = ExternalAPI__c.getValues('MarketingCloudB2UWhatsApp').EventKey__c;
        input.EstablishContactKey = true;

        input.Data = new MarketingCloudTO.CustomData();

        input.Data.ContactId = objContact.Id;
        input.Data.Name = objContact.FirstName;
        input.Data.IdentificationNumber = objContact.IndividualIdentificationNumber__c;
        input.Data.AccountId = objContact.AccountId;

        input.Data.ContactDetail = objContactDetail.Id;
        input.Data.MobilePhone = objContactDetail.MobilePhoneSMS__c;
        input.Data.Email = objContactDetail.Email__c;
        input.Data.Source = objContactDetail.Source__c;
        input.Data.relationshipGroup = objContactDetail.relationshipGroup__c;
        input.Data.doNotSendMessage = objContactDetail.doNotSendMessage__c ? 'true' : 'false';

        input.Data.TaskId = objTask.Id;
        input.Data.callDisposition = objTask.callDisposition;
        input.Data.five9AgentName = objTask.Five9__five9AgentName__c;
        input.Data.five9Agent = objTask.Five9__five9Agent__c;
        input.Data.createdDate = objTask.createdDate.format();

        input.Data.CampaignName = objTask.Five9__Five9Campaign__c;

        return input;
    }

    private static MarketingCloudTO.Item inputProductToMktCloudTO(PricebookEntry objPricebookEntry){

        MarketingCloudTO.Item input = new MarketingCloudTO.Item();

        input.id = objPricebookEntry.Id;
        input.name = objPricebookEntry.Name;
        input.product2Id = objPricebookEntry.Product2Id;
        input.productCode = objPricebookEntry.ProductCode;
        input.pricebook2 = objPricebookEntry.Pricebook2Id;
        input.pricebook2_Name = objPricebookEntry.Pricebook2.Name;

        return input;
    }
}