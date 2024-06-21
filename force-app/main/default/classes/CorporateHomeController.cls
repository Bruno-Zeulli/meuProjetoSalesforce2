/**
 * @description Classe para prover informações para a home page do Cockpit
 */
public class CorporateHomeController {
    Date dtsystem;
    /**
     * @description Método construtor
     */
    public CorporateHomeController(){
        dtsystem = Date.today();
    }
    public class homeObjInformation
    {
        /**
         * @description Método construtor
         */
        public homeObjInformation(){}

        /**
         * @description Método que retorna as informações pra home
         */
        @AuraEnabled
        public List<String> contractVincendosSumarizado;
        /**
         * @description Método que retorna as informações pra home
         */
        @AuraEnabled
        public List<Contract2__c> contractVincendosLst;
        /**
         * @description Método que retorna as informações pra home
         */
        @AuraEnabled
        public List<User> userInformation;
        /**
         * @description Método que retorna as informações pra home
         */
        @AuraEnabled
        public List<Report> userReportIds;
        /**
         * @description Método que retorna as informações pra home
         */
        @AuraEnabled
        public List<Account> accountFeedCustmerLst;
        /**
         * @description Método que retorna as informações pra home
         */
        @AuraEnabled
        public List<Order> orderFeedCustmerLst;
        /**
         * @description Método que retorna as informações pra home
         */
        @AuraEnabled
        public List<Opportunity> opportunityFeedCustmerLst;
        /**
         * @description Método que retorna as informações pra home
         */
        @AuraEnabled
        public List<Order> orderEndorssementFeedCustmerLst;
        /**
         * @description Método que retorna as informações pra home
         */
        @AuraEnabled
        public List<Quote> quoteFeedCustmerLst;
        /**
         * @description Método que retorna as informações pra home
         */
        @AuraEnabled
        public List<CMS_INTERNAL__c> cnlst;
        /**
         * @description Método que retorna as informações pra home
         */
        @AuraEnabled
        public List<AggregateResult> cnlikes;
        /**
         * @description Método que retorna as informações pra home
         */
        @AuraEnabled
        public List<AggregateResult> cnComments;

    }
    /**
     * @description Métodos que retornan informações da classe interna da homeinformation
     */
    @AuraEnabled
    public static homeObjInformation getCorporateNews(){
        homeObjInformation homeInformations = new homeObjInformation();
        Map<String, String> mapCmsInternal = new Map<String, String>();

        List<CMS_INTERNAL__c> lstCMSInternal = ([SELECT ID, Title__c, Summary__c, CreatedById, CreatedBy.Name, CreatedBy.Profile.Name, CreatedDate FROM cms_internal__c WHERE isactive__c = TRUE ORDER BY CreatedDate DESC LIMIT 3]);
        if(lstCMSInternal.size() > 0){
            homeInformations.cnlst = lstCMSInternal;

            List<User> lstUser = new List<User>();
            for(CMS_INTERNAL__c lpCMSItem : lstCMSInternal){
                User usrAdd = new User(id = lpCMSItem.CreatedById);
                    lstUser.add(usrAdd);
                    mapCmsInternal.put(lpCMSItem.id,lpCMSItem.id);
            }
            List<User> lstUserPicture = ([SELECT SmallPhotoUrl, Id, Name FROM User WHERE id IN : lstUser]);
            if(lstUserPicture.size() > 0){
                homeInformations.userInformation = lstUserPicture;
            }
        }
        List<String> lstCMSId = new List<String>();
        lstCMSId = mapCmsInternal.values();
        if(lstCMSId.size() > 0){
            List<AggregateResult> lstLikes = ([SELECT SUM(Likes__c)TotalLikes, cms_internal_id__c from cms_interaction__c WHERE cms_internal_id__c IN : lstCMSId Group By cms_internal_id__c ]);
            homeInformations.cnlikes = lstLikes;

            List<AggregateResult> lstComments = ([SELECT COUNT(id)TotalComents, cms_internal_id__c from cms_interaction__c WHERE comments__c != '' AND cms_internal_id__c IN : lstCMSId Group By cms_internal_id__c ]);
            homeInformations.cnComments = lstComments;
        }
        /**
         * @description RETORNA AS INFORMAÇÕES DO CNEWS PRA HOME
         */
        return homeInformations;
    }
    /**
     * @description Métodos que retornan informações DE VINCENDOS PARA A HOME
     */
    @AuraEnabled
    public static homeObjInformation getVincendosRecordsSumarrized(){
        homeObjInformation homeInformations = new homeObjInformation();

        String userId = UserInfo.getUserId();
        String profileId = UserInfo.getProfileId();
        String strPrfName = '';
        Integer it90 = 0;
        Integer it60 = 0;
        Integer it45 = 0;
        Integer it30 = 0;

        List<Profile> profileList = [SELECT Name FROM Profile WHERE Id =:profileId];
        for(Profile prfl : profileList){
            strPrfName = prfl.Name;
        }
        if(!strPrfName.contains('Gerente Regional'))
        {
            List<Contract2__c> lstVincendoRecords = ([SELECT id, ExpirationDayNumber__c
                                                    FROM    Contract2__c
                                                    WHERE   ExpirationDayNumber__c <= 90 AND Status__c = 'Ativo' and Account__r.OwnerId = : userId]);
            if(lstVincendoRecords.size() > 0){
                for(Contract2__c lpContract : lstVincendoRecords){
                    if(lpContract.ExpirationDayNumber__c > 60){
                        it90 += 1;
                    }else if(lpContract.ExpirationDayNumber__c > 45){
                        it60 += 1;
                    }else if(lpContract.ExpirationDayNumber__c > 30){
                        it45 += 1;
                    }else{
                        it30 += 1;
                    }
                }
            }

            List<String> lstRecordsSumarrized = new String[4];
            lstRecordsSumarrized[0] = String.valueOf(it90);
            lstRecordsSumarrized[1] = String.valueOf(it60);
            lstRecordsSumarrized[2] = String.valueOf(it45);
            lstRecordsSumarrized[3] = String.valueOf(it30);
            homeInformations.contractVincendosSumarizado = lstRecordsSumarrized;
            List<Contract2__c> lstContratosVincendos = ([SELECT id, BidNumber__c, Account__r.Name, ProductName__c, Format(EndDate__c)
                                                        FROM Contract2__c
                                                        WHERE ExpirationDayNumber__c <= 90
                                                        AND Status__c = 'Ativo'
                                                        AND Account__r.OwnerId = : userId
                                                        ORDER BY EndDate__c DESC Limit 20]);
            if(lstContratosVincendos.size() > 0){
                homeInformations.contractVincendosLst = lstContratosVincendos;
            }
        }
        else
        {
            List<String> lstUserIds = new List<String>();
            Map<Id, String> mapUser = new Map<Id, String>();
            mapUser.put(userId, userId);

            List<User> lstUser = new List<User>([SELECT id FROM User where ManagerId =: userId AND IsActive = TRUE]);
            if(lstUser.size() > 0){
                for(User lpUsr : lstUser){
                    mapUser.put(lpUsr.Id, lpUsr.Id);
                }
            }
            lstUserIds = mapUser.values();

            List<Contract2__c> lstVincendoRecords = ([SELECT id, ExpirationDayNumber__c
                                                    FROM    Contract2__c
                                                    WHERE   ExpirationDayNumber__c <= 90 AND Status__c = 'Ativo' and Account__r.OwnerId IN : lstUserIds]);
            if(lstVincendoRecords.size() > 0){
                for(Contract2__c lpContract : lstVincendoRecords){
                    if(lpContract.ExpirationDayNumber__c > 60){
                        it90 += 1;
                    }else if(lpContract.ExpirationDayNumber__c > 45){
                        it60 += 1;
                    }else if(lpContract.ExpirationDayNumber__c > 30){
                        it45 += 1;
                    }else{
                        it30 += 1;
                    }
                }
            }

            List<String> lstRecordsSumarrized = new String[4];
            lstRecordsSumarrized[0] = String.valueOf(it90);
            lstRecordsSumarrized[1] = String.valueOf(it60);
            lstRecordsSumarrized[2] = String.valueOf(it45);
            lstRecordsSumarrized[3] = String.valueOf(it30);
            homeInformations.contractVincendosSumarizado = lstRecordsSumarrized;
            List<Contract2__c> lstContratosVincendos = ([SELECT id, BidNumber__c, Account__r.Name, ProductName__c, Format(EndDate__c)
                                                        FROM Contract2__c
                                                        WHERE ExpirationDayNumber__c <= 90
                                                        AND Status__c = 'Ativo'
                                                        AND Account__r.OwnerId IN : lstUserIds
                                                        ORDER BY EndDate__c ASC Limit 20]);
            if(lstContratosVincendos.size() > 0){
                homeInformations.contractVincendosLst = lstContratosVincendos;
            }
        }
        /**
         * @description RETORNA AS INFORMAÇÕES DE VINCENDOS PRA HOME
         */
        return homeInformations;
    }

    @AuraEnabled
    public static homeObjInformation getReporIds(){
        homeObjInformation homeInformations = new homeObjInformation();
        List<Report> lstReport = ([ SELECT  id, DeveloperName
                                    FROM    Report
                                    WHERE   FolderName = 'Corporate Cockpit'
                                    ]);
        if(lstReport.size() > 0){
            homeInformations.userReportIds = lstReport;
        }
        System.debug('HOME INFO: '+homeInformations);
        return homeInformations;
    }
    /**
     * @description Métodos que retornan informações do feed de clientes
     */
    @AuraEnabled
    public static homeObjInformation getCustomerFeed(){
        List<Account> lstAccount = new LIst<Account>();
        Map<Id, Account> mapAccSObj = new Map<Id, Account>();

        homeObjInformation homeInformations = new homeObjInformation();

        String userId = UserInfo.getUserId();
        String profileId = UserInfo.getProfileId();
        String strPrfName = '';

        List<Profile> profileList = [SELECT Name FROM Profile WHERE Id =:profileId];
        for(Profile prfl : profileList){
            strPrfName = prfl.Name;
        }

        if(!strPrfName.contains('Gerente Regional'))
        {

            List<Order> lstOrder = ([SELECT ID, Account.Name, AccountId, LastModifiedDate, OrderNumber, PoNumber FROM ORDER WHERE RecordType.Name = 'Corporate - Apólice' AND OwnerId =:userId AND LastModifiedDate = LAST_N_DAYS:7 Order by LastModifiedDate LIMIT 10]);
            if(lstOrder.size() > 0){
                for(Order lpOrd : lstOrder){
                    Account accRecord = new Account(
                        Id = lpOrd.AccountId,
                        Name = lpOrd.Account.Name
                    );
                    mapAccSObj.put(lpOrd.AccountId, accRecord);
                    homeInformations.orderFeedCustmerLst = lstOrder;
                }
            }
            List<Opportunity> lstOpportunity = ([SELECT ID, Account.Name, AccountId, LastModifiedDate, Name, Type FROM Opportunity WHERE OwnerId =:userId AND LastModifiedDate = LAST_N_DAYS:7 Order by LastModifiedDate  LIMIT 10]);
            if(lstOpportunity.size() > 0){
                for(Opportunity lpOpp : lstOpportunity){
                    Account accRecord = new Account(
                        Id = lpOpp.AccountId,
                        Name = lpOpp.Account.Name
                    );
                    mapAccSObj.put(lpOpp.AccountId, accRecord);
                    homeInformations.opportunityFeedCustmerLst = lstOpportunity;
                }
            }
            List<Order> lstOrdEndorssement = ([SELECT ID, Account.Name, AccountId, LastModifiedDate, OrderNumber, PoNumber FROM ORDER WHERE RecordType.Name IN('Corporate - Endosso Movimentação de Prêmio','Corporate - Endosso Neutro') AND OwnerId =:userId AND LastModifiedDate = LAST_N_DAYS:7 Order by LastModifiedDate  LIMIT 10]);
            if(lstOrdEndorssement.size() > 0){
                for(Order lpOrdEnd : lstOrdEndorssement){
                    Account accRecord = new Account(
                        Id = lpOrdEnd.AccountId,
                        Name = lpOrdEnd.Account.Name
                    );
                    mapAccSObj.put(lpOrdEnd.AccountId, accRecord);
                    homeInformations.orderEndorssementFeedCustmerLst = lstOrder;
                }
            }
            List<Quote> lstQuotes = ([SELECT ID, Account.Name, AccountId, LastModifiedDate, OpportunityId FROM Quote WHERE OwnerId =:userId AND LastModifiedDate = LAST_N_DAYS:7 Order by LastModifiedDate LIMIT 10]);
            if(lstQuotes.size() > 0){
                for(Quote lpQuote : lstQuotes){
                    Account accRecord = new Account(
                        Id = lpQuote.AccountId,
                        Name = lpQuote.Account.Name
                    );
                    mapAccSObj.put(lpQuote.AccountId, accRecord);
                    homeInformations.quoteFeedCustmerLst = lstQuotes;
                }
            }
            lstAccount = mapAccSObj.values();
        }
        else
        {
            List<String> lstUserIds = new List<String>();
            Map<Id, String> mapUser = new Map<Id, String>();
            mapUser.put(userId, userId);

            List<User> lstUser = new List<User>([SELECT id FROM User where ManagerId =: userId AND IsActive = TRUE]);
            if(lstUser.size() > 0){
                for(User lpUsr : lstUser){
                    mapUser.put(lpUsr.Id, lpUsr.Id);
                }
            }

            lstUserIds = mapUser.values();

            List<Order> lstOrder = ([SELECT ID, Account.Name, AccountId, LastModifiedDate, OrderNumber, PoNumber
                                    FROM    ORDER
                                    WHERE   LastModifiedDate = LAST_N_DAYS:7
                                    AND     OwnerId IN : lstUserIds
                                    AND     RecordType.Name = 'Corporate - Apólice'
                                    ORDER BY LastModifiedDate  LIMIT 10]);
            if(lstOrder.size() > 0){
                for(Order lpOrd : lstOrder){
                    Account accRecord = new Account(
                        Id = lpOrd.AccountId,
                        Name = lpOrd.Account.Name
                    );
                    mapAccSObj.put(lpOrd.AccountId, accRecord);
                }
            }
            List<Opportunity> lstOpportunity = ([SELECT ID, Account.Name, AccountId, LastModifiedDate, Name, Type FROM Opportunity WHERE OwnerId IN : lstUserIds  AND LastModifiedDate = LAST_N_DAYS:7 Order by LastModifiedDate  LIMIT 10]);
            if(lstOpportunity.size() > 0){
                for(Opportunity lpOpp : lstOpportunity){
                    Account accRecord = new Account(
                        Id = lpOpp.AccountId,
                        Name = lpOpp.Account.Name
                    );
                    mapAccSObj.put(lpOpp.AccountId, accRecord);
                }
            }
            List<Order> lstOrdEndorssement = ([SELECT ID, Account.Name, AccountId, LastModifiedDate, OrderNumber, PoNumber FROM ORDER WHERE RecordType.Name IN('Corporate - Endosso Movimentação de Prêmio','Corporate - Endosso Neutro') AND OwnerId IN : lstUserIds  AND LastModifiedDate = LAST_N_DAYS:7 Order by LastModifiedDate  LIMIT 10]);
            if(lstOrdEndorssement.size() > 0){
                for(Order lpOrdEnd : lstOrdEndorssement){
                    Account accRecord = new Account(
                        Id = lpOrdEnd.AccountId,
                        Name = lpOrdEnd.Account.Name
                    );
                    mapAccSObj.put(lpOrdEnd.AccountId, accRecord);
                }
            }
            List<Quote> lstQuotes = ([ SELECT ID, Account.Name, AccountId, LastModifiedDate, OpportunityId FROM Quote WHERE OwnerId IN : lstUserIds  AND LastModifiedDate = LAST_N_DAYS:7 Order by LastModifiedDate  LIMIT 10]);
            if(lstQuotes.size() > 0){
                for(Quote lpQuote : lstQuotes){
                    Account accRecord = new Account(
                        Id = lpQuote.AccountId,
                        Name = lpQuote.Account.Name
                    );
                    mapAccSObj.put(lpQuote.AccountId, accRecord);
                }
            }

        }
        lstAccount = mapAccSObj.values();
        homeInformations.accountFeedCustmerLst = lstAccount;
        /**
         * @description RETORNA AS INFORMAÇÕES DO CNEWS PRA HOME
         */
        return homeInformations;
    }
    /**
     * @description Métodos que retornan informações do cliente do feed de clientes
     */
    @AuraEnabled
    public static homeObjInformation getCustomerDataFeed(string customerId){

        homeObjInformation homeInformations = new homeObjInformation();
        String strCustomerId = customerId;

        List<Order> lstOrder = ([SELECT ID, Account.Name, AccountId, LastModifiedDate, OrderNumber, PoNumber FROM ORDER WHERE RecordType.Name = 'Corporate - Apólice' AND AccountId =: strCustomerId AND LastModifiedDate = LAST_N_DAYS:7 Order by LastModifiedDate]);
        if(lstOrder.size() > 0){
            homeInformations.orderFeedCustmerLst = lstOrder;
        }
        List<Opportunity> lstOpportunity = ([SELECT ID, Account.Name, AccountId, FORMAT(LastModifiedDate), Name, Type FROM Opportunity WHERE AccountId =: strCustomerId AND LastModifiedDate = LAST_N_DAYS:7 Order by LastModifiedDate]);
        if(lstOpportunity.size() > 0){
            homeInformations.opportunityFeedCustmerLst = lstOpportunity;
        }

        List<Order> lstOrdEndorssement = ([ SELECT ID, Account.Name, AccountId, FORMAT(LastModifiedDate), OrderNumber, PoNumber FROM ORDER WHERE RecordType.Name IN('Corporate - Endosso Movimentação de Prêmio','Corporate - Endosso Neutro') AND AccountId =: strCustomerId AND LastModifiedDate = LAST_N_DAYS:7 Order by LastModifiedDate]);
        if(lstOrdEndorssement.size() > 0){
            homeInformations.orderEndorssementFeedCustmerLst = lstOrder;
        }

        List<Quote> lstQuotes = ([ SELECT ID, Account.Name, AccountId, FORMAT(LastModifiedDate), OpportunityId, Name FROM Quote WHERE AccountId =: strCustomerId AND LastModifiedDate = LAST_N_DAYS:7 Order by LastModifiedDate]);

        if(lstQuotes.size() > 0){
            homeInformations.quoteFeedCustmerLst = lstQuotes;
        }
        /**
         * @description RETORNA AS INFORMAÇÕES DO CNEWS PRA HOME
         */
        return homeInformations;
    }
    /**
     * @description Métodos que retornan informações do USUÁRIO
     */
    @AuraEnabled
    public static homeObjInformation fetchUser(){

    homeObjInformation homeInformations = new homeObjInformation();
        List<User> lstUser = new List<User>([SELECT id, Name, ProfileId, Profile.Name FROM User WHERE id = :userInfo.getUserId()]);
        homeInformations.userInformation = lstUser;
    /**
     * @description RETORNA AS INFORMAÇÕES DO USUÁRIO
     */
    return homeInformations;
    }
}