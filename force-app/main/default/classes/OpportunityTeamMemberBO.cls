public without sharing class OpportunityTeamMemberBO {

    /**
    * @description declaração de variaveis */
    private static final OpportunityTeamMemberBO INSTANCE = new OpportunityTeamMemberBO();

    /**
    * @description constroi a instancia da classe OpportunityBO
    * @return instancia da classe OpportunityBO
    */
    public static OpportunityTeamMemberBO getInstance(){
        return INSTANCE;
    }


    public void updateListOpportunityTeamMember(List<OpportunityTeamMember> lstOppTeamMemberUpdate){
        
        if(!lstOppTeamMemberUpdate.isEmpty()){
            Savepoint sp = Database.setSavepoint();
            try{
                Database.SaveResult[] srListOppTeamMember = Database.update(lstOppTeamMemberUpdate, false);
            } catch (Exception e){
                System.Debug(e);
                Database.rollback(sp);
            }
        }
    }


    
}