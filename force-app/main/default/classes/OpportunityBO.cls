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
public without sharing class OpportunityBO {

    /**
    * @description declaração de variaveis */
    private static final OpportunityBO INSTANCE = new OpportunityBO();

    /**
    * @description constroi a instancia da classe OpportunityBO
    * @return instancia da classe OpportunityBO.
    */
    public static OpportunityBO getInstance(){
        return INSTANCE;
    }

    public void sendNofiticationHasQuotes(List<Opportunity> lstOpportunity){
        String msgType = 'sendNotificationHasQuote';
        List<Opportunity> lstOpportunitiesToUpdate = new List<Opportunity>();

        ChatterUtils.getInstance().makeMessagePostChatters(msgType, lstOpportunity, null);

        for(Opportunity objOpportunity: lstOpportunity){
            if(objOpportunity.StageName == 'Cotação'){

                Opportunity objOppUpdateStage = new Opportunity(
                    Id = objOpportunity.Id,
                    StageName = 'Construção da proposta'
                );
                lstOpportunitiesToUpdate.add(objOppUpdateStage);
            }
        }

        if(!lstOpportunitiesToUpdate.isEmpty()){
            lstUpdOpportunities(lstOpportunitiesToUpdate);
        }
    }

    public void lstUpdOpportunities(List<Opportunity> lstUpdOpportunity){

        if(!lstUpdOpportunity.isEmpty()){
            Savepoint sp = Database.setSavepoint();
            try{
                Database.SaveResult[] srListOpportunityUpdate = Database.update(lstUpdOpportunity, false);
            } catch (Exception e){
                System.Debug(e);
                Database.rollback(sp);
            }
        }
    }
}