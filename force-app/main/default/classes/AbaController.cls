/**
 * @description       :
 * @author            : samuelsirkis@wiz.co
 * @group             :
 * @last modified on  : 11-03-2023
 * @last modified by  : samuelsirkis@wiz.co
**/
public class AbaController {
    @AuraEnabled
    public static String updateCaseOfChatTranscript(Id recordId){
        // LiveChatTranscript chatTranscript = [SELECT Id, IndividualIdentificationNumber__c, ContactId, AccountId, CaseId FROM LiveChatTranscript WHERE Id = :recordId LIMIT 1];
        // if(chatTranscript.CaseId != null){
        //     Case caso = [SELECT Id, ContactId, AccountId FROM Case WHERE Id = :chatTranscript.CaseId LIMIT 1];
        //     if((caso.ContactId != chatTranscript.ContactId) || (caso.AccountId != chatTranscript.AccountId)){
        //         caso.ContactId = chatTranscript.ContactId;
        //         caso.AccountId = chatTranscript.AccountId;

        //         update caso;
        //         return caso.ContactId;
        //     }
        // }
        //REMOVER DEPOIS COMENTARIO
        return 'Não tenho Caso';
    }
}