/**
 * @description       : Batch para processar os call logs duplicados
 * @author            : italosilva.mirante@wiz.co
 * @group             :
 * @last modified on  : 
 * @last modified by  : 
 * Modifications Log
 * Ver  Date            Author                      Modification
 * 1.0  02-08-2024      italosilva.mirante@wiz.co        Initial Version
 **/
public with sharing class DeleteDuplicateCallLogsService{

    public void execute(){
        List<AggregateResult> scope = [SELECT ReferenceId__c, count(Id) total, format(min(CreatedDate)), format(max(CreatedDate)), min(Status__c) , max(Status__c), max(TempoDeEspera__c) from CallLog__c where CreatedDate <= TODAY group by ReferenceId__c having count(Id)> 1 order by max(CreatedDate) desc LIMIT 2000];

        List<String> refIdList =  new List<String>();

        for (AggregateResult ar : scope) {
            refIdList.add((String)ar.get('ReferenceId__c'));
        }

        List<CallLog__c> myList = [SELECT Id,Status__c, ReferenceId__c, CreatedDate FROM CallLog__c WHERE ReferenceId__c IN :refIdList];

        Map<String, List<CallLog__c>> myMap = new Map<String, List<CallLog__c>>();

        for(CallLog__c call : myList){
            if(myMap.get(call.ReferenceId__c) != null){
                myMap.get(call.ReferenceId__c).add(call);
            }else{
                myMap.put(call.ReferenceId__c, new List<CallLog__c>{call});
            }
        }

        List<String> idsToDelete = new List<String>();

        for(String str : myMap.keySet()){
            String idToDelete = '';
            for(CallLog__c cl : myMap.get(str)){
                if(cl.Status__c == 'CONECTADO'){
                idToDelete = cl.Id;
                }
            }

            idsToDelete.add(idToDelete);
        }

        System.debug(idsToDelete.size());
        delete [SELECT Id FROM CallLog__c WHERE Id IN:idsToDelete];
    }
}