public with sharing class Corporate_RenewalOpportunityBatch implements Database.Batchable<SObject>{
    public Database.QueryLocator start(Database.BatchableContext bC){

        String query = 'SELECT Id, OpportunityId, Opportunity.OpportunityNumber__c, Opportunity.Amount, AccountId, Opportunity.RecordTypeId, Opportunity.LeadSource, Owner.Name, '
                     + 'Opportunity.Pricebook2Id, Opportunity.Latest_Order_EndDate__c, Opportunity.Product_Name__c, Account.OwnerId, Account.Owner.Email, Account.Owner.Manager.Email, '
                     + 'OrderNumber, PoNumber, Account.Owner.IsActive, Account.Owner.Name, Account.Name, Company__c, Opportunity.InsuredAmount__c, TotalAmount, EffectiveDate, EndDate_Compiled__c, '
                     + '(SELECT Id, CommissionValue__c, PricebookEntryId, PricebookEntry.Product2.Name, PricebookEntry.Pricebook2Id, Product2.isActive FROM OrderItems LIMIT 1), '
                     + '(SELECT id,BrokerName__c, CommissionPercent__c FROM Commissions__r WHERE Broker__c !=null) '
                     + 'FROM Order '
                     + 'WHERE Opportunity.Product_Renewal_Start_Date__c = TODAY AND '
                     + 'Opportunity.Latest_Child_Opportunity__c = NULL AND '
                     + '(NOT Opportunity.Product_Name__c LIKE \'Vida%\') AND '
                     + 'RecordType.DeveloperName IN (\'CorporateApolice\',\'Wgarantia\',\'CorporateBeneficiosSubcontrato\',\'Corretora_Externa\') AND '
                     + '(Opportunity.RecordType.DeveloperName LIKE \'%Corporate%\' OR Opportunity.RecordType.DeveloperName = \'Corretora_Externa\') AND '
                     + 'Opportunity.StageName != \'Fechado e Perdido\' AND '
                     + 'Id IN (Select OrderId FROM OrderItem) AND '
                     + 'ParentId__c=NULL AND '
                     + 'Opportunity.Status_Portal__c IN (\'Vigente\',\'A Expirar\')';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bC, List<sObject> scope){
        Map<Id,Opportunity> oppsToInsert = new Map<Id,Opportunity>();
        List<OpportunityLineItem> oppLIToInsert = new List<OpportunityLineItem>();
        Map<Id,Order> mapIdOrder = new Map<Id,Order>();
        Id pricebookId;
        String alternativeOwnerName;
        String alternativeRecipientName;
        User alternativeOwner;
        String alternativeRecipientEmail = RenewCorporateConstants__mdt.getInstance('ErrorEmailRecipient').Value__c;
        List<OrgWideEmailAddress> orgEmail = [SELECT Id FROM OrgWideEmailAddress LIMIT 1];
        List<Messaging.SingleEmailMessage> emailListToSend = new List<Messaging.SingleEmailMessage>();
        try{
            alternativeOwnerName = RenewCorporateConstants__mdt.getInstance('AlternativeOwner').Value__c;
            alternativeRecipientName = RenewCorporateConstants__mdt.getInstance('AlternativeRecipient').Value__c;
            alternativeOwner = [SELECT Id FROM User WHERE Name = :alternativeOwnerName AND IsActive = true LIMIT 1];
            alternativeRecipientEmail = [SELECT Email FROM User WHERE Name = :alternativeRecipientName AND IsActive = true LIMIT 1].Email;
        }catch(Exception e){
            String body = 'Corporate_RenewalOpportunityBatch - Line: ' + e.getLineNumber() + ' - ' + e.getMessage(); 
            emailListToSend.add(sendEmailError(body,orgEmail.get(0).Id));
        }
        for(Order order:(List<Order>) scope){
            String productName = order.OrderItems.get(0).PricebookEntry.Product2.Name;
            if(!order.OrderItems.get(0).Product2.isActive){
                productName = '[INCLUIR PRODUTO]';
            }
            mapIdOrder.put(order.Id,order);
            Opportunity oppToAdd = new Opportunity();
            oppToAdd.Name = 'Renovação - ' + productName + ' - Pedido ' + order.OrderNumber;
            oppToAdd.CloseDate = order.Opportunity.Latest_Order_EndDate__c;
            oppToAdd.StageName = 'Aberto';
            oppToAdd.AccountId = order.AccountId;
            oppToAdd.Pricebook2Id = order.OrderItems.get(0).PricebookEntry.Pricebook2Id;
            oppToAdd.RecordTypeId = order.Opportunity.RecordTypeId;
            oppToAdd.Type = 'ReNew';
            oppToAdd.ParentOpportunity__c = order.OpportunityId;
            oppToAdd.LeadSource = order.Opportunity.LeadSource;
            oppToAdd.InsuredAmount__c = order.Opportunity.InsuredAmount__c;
            oppToAdd.Amount = order.TotalAmount;
            oppToAdd.ParentOrderId__c = order.Id;
            oppToAdd.ProbabilityOfWinning__c = 'Alto';
            oppToAdd.OwnerId = order.Account.Owner.IsActive ? order.Account.OwnerId : alternativeOwner.Id;
            oppsToInsert.put(order.OpportunityId,oppToAdd);
        }

        List<Id> successOppIds = new List<Id>();
        List<Database.Error> errorListInsertOpp = new List<Database.Error>();
        if(!oppsToInsert.isEmpty()){
            Database.SaveResult[] srInsertOpp = Database.insert(oppsToInsert.values(), false);
            for(Database.SaveResult sr:srInsertOpp){
                if(sr.isSuccess()){
                    successOppIds.add(sr.getId());
                }else{
                    errorListInsertOpp.addAll(sr.getErrors());
                }
            }
        }

        if(!errorListInsertOpp.isEmpty()){
            String bodyError;
            for(Database.Error er:errorListInsertOpp){
                bodyError = 'StatusCode: '+ er.getStatusCode() + ', Message: ' + er.getMessage() + ', Fields: ' + er.getFields() + '<br/>';
            }
            emailListToSend.add(sendEmailError(bodyError,orgEmail.get(0).Id));
        }

        if(!successOppIds.isEmpty()){
            
            for(Opportunity opp:[SELECT Id, Name, OpportunityNumber__c, ParentOrderId__c FROM Opportunity WHERE Id IN :successOppIds]){
                
                Order ord = mapIdOrder.get(opp.ParentOrderId__c);
                
                String emailBody = ord.Account.Owner.isActive ? '<p>'+ord.Account.Owner.Name+', bom dia!</p>' : '<p>Bom dia!</p>';
                emailBody += '<p>A apólice abaixo está próxima do término de vigência. Por favor, entre em contato com o cliente para garantir a renovação!</p>' +
                                '<p><strong>IMPORTANTE:</strong> A nova oportunidade de renovação já foi criada automaticamente e a negociação deve seguir pela Oportunidade abaixo (para acessar, clique no link). O acompanhamento do KR de renovação e a apuração de RV levarão em consideração esta oportunidade</p><br/>' +
                                '<p>Oportunidade de renovação: <a href=\"https://wiz.my.site.com/wizsales/s/detail/' + opp.Id + '\">' + opp.OpportunityNumber__c + ' - ' + opp.Name + '</a></p>' +
                                '<p>Conta: <a href=\"https://wiz.my.site.com/wizsales/s/account/' + ord.AccountId + '/view\">' + ord.Account.Name + '</a>' + '<br/>' +
                                'Responsável pela conta: ' + ord.Account.Owner.Name + '<br/><br/>' +
                                'Pedido: <a href=\"https://wiz.my.site.com/wizsales/s/order/' + ord.Id + '/detail\">' + ord.OrderNumber + ' (Apólice: ' + ord.PoNumber + ')' + '</a>' + ', Oportunidade: ' + ord.Opportunity.OpportunityNumber__c + '<br/>' +
                                'Início Vigência: ' + ord.EffectiveDate.format() + '<br/>' +
                                'Responsável pela emissão: ' + ord.Owner.Name + '<br/>' +
                                '<strong>Término de vigência: ' + ord.EndDate_Compiled__c.format() + '</strong>'+ '<br/>' +
                                'Produto: ' + ord.OrderItems.get(0).PricebookEntry.Product2.Name + '<br/>' +
                                'Seguradora: ' + ord.Company__c + '<br/>' +
                                'IS: R$ ' + ord.Opportunity.InsuredAmount__c.setScale(2).toPlainString().replace('.', ',') + '<br/>' +
                                'Prêmio: R$ ' + ord.TotalAmount.setScale(2).toPlainString().replace('.', ',') + '<br/><br/>';
                if(ord.OrderItems.get(0).CommissionValue__c!=null){
                    emailBody += 'Comissão: R$ ' + ord.OrderItems.get(0).CommissionValue__c.setScale(2).toPlainString().replace('.', ',') + '<br/><br/>';
                }
                if(!ord.Commissions__r.isEmpty()){
                    if(ord.Commissions__r.size()==1){
                        emailBody += 'Corretora: ' + ord.Commissions__r.get(0).BrokerName__c + ' (' + ord.Commissions__r.get(0).CommissionPercent__c + '%)';
                    }else{
                        Integer i = 1;
                        for(CommissionsAndTransfers__c comission:ord.Commissions__r){
                            emailBody += 'Corretora ' + i + ': ' + comission.BrokerName__c + ' (' + comission.CommissionPercent__c + '%)<br/>';
                            i++;
                        }
                    }
                }
                if(ord.OrderItems.get(0).Product2.isActive){
                    OpportunityLineItem oppLIToAdd = new OpportunityLineItem();
                    oppLIToAdd.OpportunityId = opp.Id;
                    oppLIToAdd.PricebookEntryId = ord.OrderItems.get(0).PricebookEntryId;
                    oppLIToAdd.Quantity = 1;
                    oppLIToAdd.UnitPrice = ord.TotalAmount;
                    oppLIToAdd.ExpectedCommission__c = ord.OrderItems.get(0).CommissionValue__c;
                    oppLIToAdd.Type__c = 'ReNew';
                    oppLIToInsert.add(oppLIToAdd);
                }else{
                    String bodyNoProduct = '<p>A Oportunidade abaixo foi criada sem produto pois o produto foi inativado. Acesse a Oportunidade e inclua um produto ativo.</p>' +
                                           '<p>Oportunidade de renovação: <a href=\"https://wiz.my.site.com/wizsales/s/detail/' + opp.Id + '\">' + opp.OpportunityNumber__c + ' - ' + opp.Name + '</a></p>' +
                                           '<p>Conta: <a href=\"https://wiz.my.site.com/wizsales/s/account/' + ord.AccountId + '/view\">' + ord.Account.Name + '</a>' + '<br/>';
                    Messaging.SingleEmailMessage emailToAdd = new Messaging.SingleEmailMessage();
                    emailToAdd.setToAddresses(Test.isRunningTest() ? new List<String>{'test@test.com'} : new List<String>{alternativeRecipientEmail});
                    emailToAdd.setSubject('OPORTUNIDADE DE RENOVAÇÃO CRIADA SEM PRODUTO - Apólice: ' + ord.PoNumber + ', Oportunidade: ' + ord.Opportunity.OpportunityNumber__c);
                    emailToAdd.setHtmlBody(bodyNoProduct);
                    emailToAdd.setOrgWideEmailAddressId(orgEmail.get(0).Id);
                    emailToAdd.setWhatId(opp.Id);
                    emailListToSend.add(emailToAdd);
                }
                
                Messaging.SingleEmailMessage emailToAdd = new Messaging.SingleEmailMessage();
                List<String> toAddress = new List<String>();
                if(ord.Account.Owner.isActive){
                    toAddress.add(ord.Account.Owner.Email);
                    if(ord.Account.Owner.Manager.Email!=null){
                        toAddress.add(ord.Account.Owner.Manager.Email);
                    }
                }else{
                    toAddress.add(alternativeRecipientEmail);
                }

                if(Test.isRunningTest()){
                    toAddress = new List<String>{'test@test.com'};
                }
                emailToAdd.setToAddresses(toAddress);
                emailToAdd.setSubject('AVISO DE RENOVAÇÃO - Apólice: ' + ord.PoNumber + ', Oportunidade: ' + ord.Opportunity.OpportunityNumber__c);
                emailToAdd.setHtmlBody(emailBody);
                emailToAdd.setOrgWideEmailAddressId(orgEmail.get(0).Id);
                emailToAdd.setWhatId(opp.Id);
                emailListToSend.add(emailToAdd);   
            }
            
            if(!oppLIToInsert.isEmpty()){
                insert oppLIToInsert;
            }
        }

        if(!emailListToSend.isEmpty()){
            List<Messaging.SendEmailResult> results = Messaging.sendEmail(emailListToSend);
        }
    }

    public void finish(Database.BatchableContext bc){
    }

    private Messaging.SingleEmailMessage sendEmailError(String body, Id orgWideEmailAddressId){
        Messaging.SingleEmailMessage msgError = new Messaging.SingleEmailMessage();
        List<String> toAddressError = new List<String>();
        toAddressError.add(RenewCorporateConstants__mdt.getInstance('ErrorEmailRecipient').Value__c);
        if(Test.isRunningTest()){
            toAddressError = new List<String>{'test@test.com'};
        }
        msgError.setToAddresses(toAddressError);
        msgError.setSubject('Erro na Emissão da Renovação');
        msgError.setHtmlBody(body);
        msgError.setOrgWideEmailAddressId(orgWideEmailAddressId);
        return msgError;
    }
}