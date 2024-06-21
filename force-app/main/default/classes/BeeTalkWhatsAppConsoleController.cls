/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 10-31-2023
 * @last modified by  : samuelsirkis@wiz.co
**/
public class BeeTalkWhatsAppConsoleController {

    private static final BeeTalkWhatsAppConsoleController INSTANCE = new BeeTalkWhatsAppConsoleController();
    private static final id CHATBOT_RT_ID= Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ChatBot').getRecordTypeId();


    public static BeeTalkWhatsAppConsoleController getInstance(){
        return INSTANCE;
    }

    @AuraEnabled(cacheable=true)
    public static UserManagement__c getUserStatus(String recordId){

         try{
            return [SELECT Id, PresenceStatus__c, AutomaticReceiverChat__c, MyCasesToView__c, AwaitCasesToView__c FROM UserManagement__c WHERE User__c =: recordId];

        } catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }



    @AuraEnabled(cacheable=true)
    public static Case getCaseData(String recordId){
         try{
            return [SELECT Id, CaseNumber, Status, Origin, Product__c, Subject, UN__c, OwnerId  FROM Case WHERE Id =: recordId];

        } catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void changeActualPage(String recordId, Boolean isSelectedCase){
         try{
            Case objCase = [SELECT Id, EmResolucao_Tkt__c FROM Case WHERE Id =: recordId LIMIT 1];
            objCase.EmResolucao_Tkt__c = isSelectedCase;
            update objCase;

        } catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void changeOnlineChat(String recordId, String presenceStatus){
         try{
            UserManagement__c objUserM = [SELECT Id, PresenceStatus__c, User__c FROM UserManagement__c WHERE User__c =: recordId LIMIT 1];
            objUserM.PresenceStatus__c = presenceStatus;
            update objUserM;

        } catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }


    @AuraEnabled
    public static void changeMyCaseToView(String recordId, Integer myCasesToView){
         try{
            UserManagement__c objUserM = [SELECT Id, MyCasesToView__c, User__c FROM UserManagement__c WHERE User__c =: recordId LIMIT 1];
            objUserM.MyCasesToView__c = myCasesToView;
            update objUserM;

        } catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void changeAwaitCaseToView(String recordId, Integer awaitCasesToView){
         try{
            UserManagement__c objUserM = [SELECT Id, AwaitCasesToView__c, User__c FROM UserManagement__c WHERE User__c =: recordId LIMIT 1];
            objUserM.AwaitCasesToView__c = awaitCasesToView;
            update objUserM;

        } catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static List<Case> getMyCaseBTWhatsApp(String recordId){
          try{
            return [SELECT Id,beetalk__NameFormula__c,CaseNumber,EmResolucao_Tkt__c,ContactDetail__r.Name,Product__c,Origin, Subject, Status, OwnerId, UN__c, beetalk__SourceIdentification__c, PhoneFormula_F2__c, beetalkContactMessageNotAnswered__c, beeTalkContact__r.beetalk__LastMessage__r.CreatedDate FROM Case WHERE RecordTypeId =: CHATBOT_RT_ID AND OwnerId=:recordId AND Status = 'Em atendimento' ORDER BY beeTalkContact__r.beetalk__LastMessage__r.CreatedDate DESC];

        } catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Case> getCaseAwaitBTWhatsApp(String recordId){

        List<GroupMember> lstUserOnGroup = [SELECT GroupId, UserOrGroupId FROM GroupMember WHERE UserOrGroupId =: recordId];
        Set<Id> setIdsGroups = new Set<Id>();
        for(GroupMember objuserOnGroup : lstUserOnGroup){
            setIdsGroups.add(objuserOnGroup.GroupId);
        }
        List<GroupMember> lstGroupOnQueue = [SELECT GroupId, UserOrGroupId FROM GroupMember WHERE UserOrGroupId IN: setIdsGroups];
        Set<Id> setIdsQueues = new Set<Id>();
        for(GroupMember objGroupOnQueue : lstGroupOnQueue){
            setIdsQueues.add(objGroupOnQueue.GroupId);
        }

       return [SELECT Id,CaseNumber,ContactDetail__r.Name,Product__c,Origin,Subject,Status,UN__c,beeTalkContact__r.beetalk__MessageNotAnswered__c,beetalk__SourceIdentification__c
                FROM Case
                WHERE RecordTypeId =: CHATBOT_RT_ID AND Status = 'Aguardando atendimento' AND OwnerId IN: setIdsQueues ORDER BY CreatedDate
            ];
    }

    @AuraEnabled
    public static void getCaseToMe(String userId, String recordId){
         try{

            Case objCase = [SELECT Id, OwnerId FROM Case WHERE Id =:recordId LIMIT 1];
            objCase.OwnerId = userId;
            objCase.Status = 'Em atendimento';

            update objCase;

        } catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }


    public void DistribuiteCaseToOperador(){

        String OwnerId;
        Integer casesLimit;
        Integer NumCases;


        List<Case> lstOpenCases = [SELECT Id, OwnerId, Status FROM Case WHERE RecordTypeId =:CHATBOT_RT_ID AND Status = 'Aguardando atendimento' ORDER BY CreatedDate ASC];
        Map<String, List<String>> mapOpenCases = new Map<String, List<String>>();
        Set<Id> setQueuesId = new Set<Id>();

        for(Case openCases : lstOpenCases){
            if(mapOpenCases.containsKey(openCases.OwnerId)){
                mapOpenCases.get(openCases.OwnerId).add(openCases.Id);
            }
            else{
                mapOpenCases.put(openCases.OwnerId,new List<String>{openCases.Id});
            }
            setQueuesId.add(openCases.OwnerId);
        }

        List<GroupMember> lstGroupOnQueue = [SELECT GroupId, UserOrGroupId FROM GroupMember WHERE GroupId IN: setQueuesId];
        Map<String, String> mapGroupOnQueue = new Map<String, String>();
        Set<Id> setGroupsId = new Set<Id>();

        for(GroupMember grpOnQueue : lstGroupOnQueue){
            mapGroupOnQueue.put(grpOnQueue.GroupId, grpOnQueue.UserOrGroupId);
            setGroupsId.add(grpOnQueue.UserOrGroupId);
        }

        List<UserManagement__c> lstUserOnlineAutomaticCapacity = [SELECT Id, User__c, AutomaticReceiverChat__c, Capacity__c, PresenceStatus__c FROM UserManagement__c WHERE AutomaticReceiverChat__c = true AND PresenceStatus__c = 'Disponivel']; //AND UserRole.Name LIKE '%WhatsApp%'
        Map<String, Integer> mapUserLimit = new Map<String, Integer>();
        Set<Id> setUserOnlineAutomaticCapacity = new Set<Id>();

        for(UserManagement__c objUserM : lstUserOnlineAutomaticCapacity){
            setUserOnlineAutomaticCapacity.add(objUserM.User__c);
            mapUserLimit.put(objUserM.User__c, Integer.valueof(objUserM.Capacity__c));
        }

        List<GroupMember> lstUserOnGroup = new List<GroupMember>();
        if(!setGroupsId.isEmpty() && !setUserOnlineAutomaticCapacity.isEmpty()){
            lstUserOnGroup = [SELECT GroupId, UserOrGroupId FROM GroupMember WHERE GroupId IN :setGroupsId AND UserOrGroupId IN :setUserOnlineAutomaticCapacity];
        }

        Map<String, List<String>> mapUserOnGroup = new Map<String, List<String>>();

        for(GroupMember userOnGroup : lstUserOnGroup){
            if(mapUserOnGroup.containsKey(userOnGroup.GroupId)){
                mapUserOnGroup.get(userOnGroup.GroupId).add(userOnGroup.UserOrGroupId);
            }
            else{
                mapUserOnGroup.put(userOnGroup.GroupId, new List<String>{userOnGroup.UserOrGroupId});
            }

        }

        List<AggregateResult> lstCountCasesAttendance = [SELECT count(Id) cont, OwnerId FROM Case WHERE Status = 'Em atendimento' AND OwnerId IN:setUserOnlineAutomaticCapacity GROUP BY OwnerId];
        Map<String, Integer> mapCountCasePerUser = new Map<String, Integer>();
        if(!lstCountCasesAttendance.isEmpty()){
            for(AggregateResult objAgt : lstCountCasesAttendance){
                OwnerId = (String)objAgt.get('OwnerId');
                NumCases = (Integer)objAgt.get('cont');
                mapCountCasePerUser.put(OwnerId,NumCases);
            }
        }
        for(String str : setUserOnlineAutomaticCapacity){
            if(!mapCountCasePerUser.containsKey(str)){
                OwnerId = str;
                NumCases = 0;
                mapCountCasePerUser.put(OwnerId,NumCases);
            }
        }

        List<String> lstUser = new List<String>();
        List<Case> lstCasesToUpdate = new List<Case>();
        String groupId;

        for(Case objCase : lstOpenCases){
            groupId = mapGroupOnQueue.get(objCase.OwnerId);
            lstUser = mapUserOnGroup.get(groupId);
            if(lstUser != null){
                OwnerId = null;
                for(String userId : lstUser){
                    if(mapCountCasePerUser.containsKey(userId)){
                        if((mapCountCasePerUser.get(userId) < mapCountCasePerUser.get(OwnerId) && mapCountCasePerUser.get(userId) < mapUserLimit.get(userId)) || (OwnerId == null && mapCountCasePerUser.get(userId) < mapUserLimit.get(userId))){
                            OwnerId = userId;
                        }else if(mapCountCasePerUser.get(userId) == 0 || mapCountCasePerUser.get(userId) == null){
                            OwnerId = userId;
                        }
                    }
                }
                if(OwnerId != null){
                    objCase.OwnerId = OwnerId;
                    objCase.Status = 'Em atendimento';
                        if(mapCountCasePerUser.get(OwnerId) == 0){
                           mapCountCasePerUser.put(OwnerId,1);
                        }else{
                            mapCountCasePerUser.put(OwnerId,mapCountCasePerUser.get(OwnerId) + 1);
                        }
                    lstCasesToUpdate.add(objCase);
                }
            }
        }

        update lstCasesToUpdate;
    }
}