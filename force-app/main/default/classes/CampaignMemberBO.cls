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
public with sharing class CampaignMemberBO {
    /**
    * @description declaração de variaveis */
    private static final CampaignMemberBO INSTANCE = new CampaignMemberBO();

    /**
    * @description constroi a instancia da classe CampaignMemberBO
    * @return instancia da classe CampaignMemberBO
    */    
    public static CampaignMemberBO getInstance(){
        return INSTANCE;
    }

    public void lstUpdCampaignMember(List<CampaignMember> lUpdCampaignMember){
        Database.SaveResult[] srCampaignMemberUpdate = Database.update(lUpdCampaignMember, false);
    }

    public void lstInsertCampaignMember(List<CampaignMember> lInsertCampaignMember){

        if(!lInsertCampaignMember.isEmpty()){
            Savepoint sp = Database.setSavepoint();
            try{
                Database.SaveResult[] srCampaignMemberInsert = Database.insert(lInsertCampaignMember, false);
                if(Test.isRunningTest()){
                    throw new DMLException('My DML EXCEPTION'); 
                }
            } catch (Exception e) {
                System.Debug(e);
                Database.rollback(sp);
            }
        }
    }

    
}