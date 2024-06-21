/**
 * @description       :
 * @author            : marcelomartins@wizsoluceos.com.br
 * @group             :
 * @last modified on  : 10-29-2022
 * @last modified by  : marcelomartins@wizsoluceos.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   10-29-2022   marcelomartins@wizsoluceos.com.br    Initial Version
 **/
public without sharing class CampaignActivityBO {
    /**
    * @description declaração de variaveis */
    private static final CampaignActivityBO INSTANCE = new CampaignActivityBO();

    /**
    * @description constroi a instancia da classe CampaignActivityBO
    * @return instancia da classe CampaignActivityBO
    */    
    public static CampaignActivityBO getInstance(){
        return INSTANCE;
    }

    public void lstInsertCampaignActivity(List<CampaignActivity__c> lInsertCampaignActivity){

        if(!lInsertCampaignActivity.isEmpty()){
            Savepoint sp = Database.setSavepoint();
            try{
                Database.SaveResult[] srCampaignActivityInsert = Database.insert(lInsertCampaignActivity, false);
            } catch (Exception e){
                System.Debug(e);
                Database.rollback(sp);
            }
        }
    }

    
}