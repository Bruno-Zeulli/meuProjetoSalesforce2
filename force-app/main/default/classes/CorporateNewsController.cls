/**
 * @description Classe para a estrutura do corporate news
 */
public with sharing class CorporateNewsController {
    Date dtSystemCC;
    public CorporateNewsController(){
        dtSystemCC = Date.today();
    }
    /**
     * @description Classe interna que retorna as informações para a chamada do componente
     */
    public class corporatenewsObjInformation
    {
        Date dtSystemC;
        /**
         * @description Método construtor
         */
        public corporatenewsObjInformation(){
            dtSystemC = Date.today();
        }
        /**
         * @description Método de  retorno de informações de tela do cmp
         */
        @AuraEnabled
        public List<User> userInformation;
        /**
         * @description Método de  retorno de informações de tela do cmp
         */
        @AuraEnabled
        public List<Report> userReportIds;
        /**
         * @description Método de  retorno de informações de tela do cmp
         */
        @AuraEnabled
        public List<CMS_INTERNAL__c> cnlst;
        /**
         * @description Método de  retorno de informações de tela do cmp
         */
        @AuraEnabled
        public List<AggregateResult> cnlikes;
        /**
         * @description Método de  retorno de informações de tela do cmp
         */
        @AuraEnabled
        public List<AggregateResult> cnComments;
        /**
         * @description Método de  retorno de informações de tela do cmp
         */
        @AuraEnabled
        public List<CMS_INTERACTION__c> cnHomeComments;

    }
    /**
     * @description Métodos que retornan informações da classe interna da homeinformation
     */
    @AuraEnabled
    public static corporatenewsObjInformation getCorporateNews(){
        corporatenewsObjInformation corporatenewsObjInformations = new corporatenewsObjInformation();
        Map<String, String> mapCmsInternal = new Map<String, String>();
        Map<ID, User> mapUserInfo = new Map<ID, User>();
        List<CMS_INTERNAL__c> lstCMSInternalReturn = new List<CMS_INTERNAL__c>();
        String cmsHomeId = '';

        List<CMS_INTERNAL__c> lstCMSInternal = ([SELECT ID, Title__c, Summary__c, CreatedById, CreatedBy.Name, CreatedBy.Profile.Name, FORMAT(CreatedDate), body__c, Name FROM cms_internal__c WHERE isactive__c = TRUE ORDER BY CreatedDate Desc]);
        if(lstCMSInternal.size() > 0){
            cmsHomeId = lstCMSInternal[0].Id;

            List<User> lstUser = new List<User>();
            for(CMS_INTERNAL__c lpCMSItem : lstCMSInternal){
                User usrAdd = new User(id = lpCMSItem.CreatedById);
                    lstUser.add(usrAdd);
                    mapCmsInternal.put(lpCMSItem.id,lpCMSItem.id);
            }
            List<User> lstUserPicture = ([SELECT SmallPhotoUrl, Id, Name FROM User WHERE id IN : lstUser]);
            if(lstUserPicture.size() > 0){
                for(User lpUsr : lstUserPicture){
                    mapUserInfo.put(lpUsr.Id, lpUsr);
                }
            }
            for(CMS_INTERNAL__c lpCMSItem : lstCMSInternal){
                lpCMSItem.Name = mapUserInfo.get(lpCMSItem.CreatedById).SmallPhotoUrl;
                lstCMSInternalReturn.add(lpCMSItem);
            }
            corporatenewsObjInformations.cnlst = lstCMSInternalReturn;
        }

        List<String> lstCMSId = new List<String>();
        lstCMSId = mapCmsInternal.values();
        if(lstCMSId.size() > 0)
        {
            List<AggregateResult> lstLikes = ([SELECT SUM(Likes__c)TotalLikes, cms_internal_id__c from cms_interaction__c WHERE cms_internal_id__c IN : lstCMSId AND comments__c = '' Group By cms_internal_id__c ]);
            corporatenewsObjInformations.cnlikes = lstLikes;

            List<AggregateResult> lstComments = ([SELECT COUNT(id)TotalComents, cms_internal_id__c from cms_interaction__c WHERE comments__c != '' AND cms_internal_id__c IN : lstCMSId Group By cms_internal_id__c ]);
            corporatenewsObjInformations.cnComments = lstComments;

            List<CMS_INTERACTION__c> lstCommentsHome = ([SELECT cms_internal_id__c, comments__c,  FORMAT(CreatedDate), CreatedBy.Name, CreatedBy.Profile.Name FROM cms_interaction__c WHERE cms_internal_id__c = : cmsHomeId AND comments__c != '' ORDER BY CreatedDate]);
            corporatenewsObjInformations.cnHomeComments = lstCommentsHome;
        }
        /**
         * @description retorna o objeto da classe de dados
         */
        return corporatenewsObjInformations;
    }

    /**
     * @description Métodos que retornan informações da classe interna da homeinformation
     */
    @AuraEnabled
    public static corporatenewsObjInformation getRecordCNews(String idrecordcnew){
        corporatenewsObjInformation corporatenewsObjInformations = new corporatenewsObjInformation();
        Map<String, String> mapCmsInternal = new Map<String, String>();
        Map<ID, User> mapUserInfo = new Map<ID, User>();
        List<CMS_INTERNAL__c> lstCMSInternalReturn = new List<CMS_INTERNAL__c>();
        String cmsId = idrecordcnew;

        List<CMS_INTERNAL__c> lstCMSInternal = ([SELECT ID, Title__c, CreatedById, CreatedBy.Name, CreatedBy.Profile.Name, CreatedDate, body__c, Name FROM cms_internal__c WHERE id = : idrecordcnew AND isactive__c = TRUE]);
        if(lstCMSInternal.size() > 0)
        {
            List<User> lstUser = new List<User>();
            for(CMS_INTERNAL__c lpCMSItem : lstCMSInternal){
                User usrAdd = new User(id = lpCMSItem.CreatedById);
                    lstUser.add(usrAdd);
                    mapCmsInternal.put(lpCMSItem.id,lpCMSItem.id);
            }
            List<User> lstUserPicture = ([SELECT SmallPhotoUrl, Id, Name FROM User WHERE id IN : lstUser]);
            if(lstUserPicture.size() > 0){
                for(User lpUsr : lstUserPicture){
                    mapUserInfo.put(lpUsr.Id, lpUsr);
                }
            }
            for(CMS_INTERNAL__c lpCMSItem : lstCMSInternal){
                lpCMSItem.Name = mapUserInfo.get(lpCMSItem.CreatedById).SmallPhotoUrl;
                lstCMSInternalReturn.add(lpCMSItem);
            }
            corporatenewsObjInformations.cnlst = lstCMSInternalReturn;
        }

        List<String> lstCMSId = new List<String>();
        lstCMSId = mapCmsInternal.values();

        if(lstCMSId.size() > 0)
        {
            List<AggregateResult> lstLikes = ([SELECT SUM(Likes__c)TotalLikes, cms_internal_id__c from cms_interaction__c WHERE cms_internal_id__c IN : lstCMSId AND comments__c = ''  GROUP BY cms_internal_id__c ]);
            corporatenewsObjInformations.cnlikes = lstLikes;

            List<AggregateResult> lstComments = ([SELECT COUNT(id)TotalComents, cms_internal_id__c FROM cms_interaction__c WHERE comments__c != '' AND cms_internal_id__c IN : lstCMSId GROUP BY cms_internal_id__c]);
            corporatenewsObjInformations.cnComments = lstComments;

            List<CMS_INTERACTION__c> lstCommentsHome = ([SELECT cms_internal_id__c, comments__c,  FORMAT(CreatedDate), CreatedBy.Name, CreatedBy.Profile.Name   FROM cms_interaction__c WHERE cms_internal_id__c = : cmsId AND comments__c != '' ORDER BY cms_internal_id__r.CreatedDate]);
            corporatenewsObjInformations.cnHomeComments = lstCommentsHome;
        }
        /**
         * @description retorna o objeto da classe de dados
         */
        return corporatenewsObjInformations;
    }

    /**
     * @description Métodos que salva os comentários no post
     */
    @AuraEnabled
    public static corporatenewsObjInformation putCommentsCNews(String strComments, String cnewsrecordId){
        corporatenewsObjInformation corporatenewsObjInformations = new corporatenewsObjInformation();
        String cmsId = cnewsrecordId;

        cms_interaction__c cnewComments = new cms_interaction__c(
            Name = '',
            cms_internal_id__c = cnewsrecordId,
            comments__c = strComments
        );
        INSERT cnewComments;

        List<CMS_INTERACTION__c> lstCommentsHome = ([SELECT cms_internal_id__c, comments__c,  FORMAT(CreatedDate), CreatedBy.Name  FROM cms_interaction__c WHERE cms_internal_id__c = : cnewsrecordId AND comments__c != '' ORDER BY CreatedDate]);
            corporatenewsObjInformations.cnHomeComments = lstCommentsHome;
        /**
         * @description retorna o objeto da classe de dados
         */
        return corporatenewsObjInformations;
    }
    /**
     * @description Métodos que salva os likes no post
     */
    @AuraEnabled
    public static corporatenewsObjInformation putLikeCNews(String cnewsrecordId){
        corporatenewsObjInformation corporatenewsObjInformations = new corporatenewsObjInformation();
        String userId = UserInfo.getUserId();
        List<cms_interaction__c> lstInteractionCheck = ([SELECT id FROM cms_interaction__c WHERE OwnerId = : userId AND comments__c = '' AND cms_internal_id__c = : cnewsrecordId LIMIT 1]);

        if(lstInteractionCheck.size() == 0){
            cms_interaction__c cnewLike = new cms_interaction__c(
                Name = '',
                cms_internal_id__c = cnewsrecordId,
                Likes__c  = 1
            );
            INSERT cnewLike;
        }

        List<AggregateResult> lstLikes = ([SELECT SUM(Likes__c)TotalLikes, cms_internal_id__c from cms_interaction__c WHERE cms_internal_id__c = : cnewsrecordId AND comments__c = '' Group By cms_internal_id__c ]);
            corporatenewsObjInformations.cnlikes = lstLikes;
        /**
         * @description retorna o objeto da classe de dados
         */
        return corporatenewsObjInformations;
    }


}