/**
 * @description       :
 * @author            : samuelsirkis@wiz.co
 * @group             :
 * @last modified on  : 26-12-2022
 * @last modified by  : samuelsirkis@wiz.co
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   26-12-2022   samuelsirkis@wiz.co                  Initial Version
 **/
public with sharing class CaseBO {

    private static final CaseBO INSTANCE = new CaseBO();

    public static CaseBO getInstance(){
        return INSTANCE;
    }

    public void updateCases(List<Case> casesToUpdate){
        Savepoint sp = Database.setSavepoint();
         try{
            Database.SaveResult[] srListCaseUpdate = Database.update(casesToUpdate, false);
        } catch (Exception e){
            System.Debug(e);
            Database.rollback(sp);
        }
    }
}