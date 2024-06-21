/**
 * @description       :
 * @author            : marcelomartins@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 11-23-2021
 * @last modified by  : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-23-2021   marcelomartins@wizsolucoes.com.br   Initial Version
 **/
public with sharing class ChatterUtils {

    /**
    * @description declaração de variaveis */
    private static final ChatterUtils INSTANCE = new ChatterUtils();

    /**
    * @description constroi a instancia da classe OpportunityDAO
    * @return instancia da classe OpportunityDAO
    */
    public static ChatterUtils getInstance(){
        return INSTANCE;
    }

   public void postChatters(List<Opportunity> lstOpportunities, Map<String, String> mapBodyByOpportunityId,  Map<String, String> mapLinkByOpportunityId){

        Set<Id> setIdsUsuarios = new Set<Id>();

        for(Opportunity opp : lstOpportunities){
            setIdsUsuarios.add(opp.OwnerId);
        }
        //postChatter(opportunity.Id, opportunity.OwnerId, body, link);

        List<User> users = [SELECT Id, IsActive FROM User WHERE Id IN :setIdsUsuarios ];

        Map<String, User> mapUserByOwnerId = new Map<String, User>();

        for(User user : users){
            mapUserByOwnerId.put(user.Id, user);
        }

        //User objUser = [SELECT IsActive FROM User WHERE Id =:userToMentionId Limit 1];
        for(Opportunity opp : lstOpportunities){
            User objUser = mapUserByOwnerId.get(opp.OwnerId);
            ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
            messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

            // add some text before the mention
            ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
            textSegment.text = 'Olá ';
            messageInput.messageSegments.add(textSegment);

            // add the mention
            ConnectApi.MentionSegmentInput mentionSegment = new ConnectApi.MentionSegmentInput();
            mentionSegment.id = opp.OwnerId;
            messageInput.messageSegments.add(mentionSegment);

            // add the text that was passed
            String postText = mapBodyByOpportunityId.get(opp.Id);
            textSegment = new ConnectApi.TextSegmentInput();
            textSegment.text = postText;
            messageInput.messageSegments.add(textSegment);

            ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
            input.body = messageInput;

            String link = mapLinkByOpportunityId.get(opp.Id);
            ConnectApi.LinkCapabilityInput linkInput = new ConnectApi.LinkCapabilityInput();
            linkInput.url = link;

            ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput = new ConnectApi.FeedElementCapabilitiesInput();
            feedElementCapabilitiesInput.link = linkInput;
            input.capabilities = feedElementCapabilitiesInput;

            input.feedElementType = ConnectApi.FeedElementType.FeedItem;
            input.subjectId = opp.Id;

            // post it
            if(objUser != null && objUser.IsActive == true && !Test.isRunningTest()){
                ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), input);
            }
        }
    }

    public void makeMessagePostChatters(String msgType, List<Opportunity> lstOpps, String complementatyParam){
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        Map<String, String> mapBodyByOpportunityId = new Map<String, String>();
        Map<String, String> mapLinkByOpportunityId = new Map<String, String>();

        for(Opportunity opportunity : lstOpps){
            String link = '';
            String body = '';

            switch on msgType {
                when  'OpportuntySendedWFlow'{

                    link = baseUrl + '/' + opportunity.Id;

                    body = '\n';
                    body += 'A oportunidade ' + opportunity.OpportunityNumber__c;
                    body += ' - ' + opportunity.Name;
                    body += ', está em tratamento pelo time de backoffice. \n';
                    body += 'Assim que disponível as cotações você será notificado! \n ';
                    body += ' Para acompanhamento o processo acesse o link.';

                    if(!Test.isRunningTest()){
                        mapBodyByOpportunityId.put(opportunity.Id,body);
                        mapLinkByOpportunityId.put(opportunity.Id,link);
                        //postChatter(opportunity.Id, opportunity.OwnerId, body, link);
                    }
                }

                when  'ApprovedQuoteSendedWFlow'{

                    link = baseUrl + '/' + opportunity.Id;
                    body = '\n';
                    body += '***Atualização na oportunidade ' + opportunity.OpportunityNumber__c;
                    body += ' - ' + opportunity.Name + '*** \n';
                    body += 'Processo de sincronização com o WFlow concluído!';
                    body += complementatyParam;
                    body += 'Aprovada e encaminhada para emissão junto a Seguradora. \n' ;
                    body += 'Você já pode concluir a opportunidade como "Fechada e Ganha" \n';
                    body += 'Para acessar o oportunidade click o link.';


                    if(!Test.isRunningTest()){
                        //postChatter(opportunity.Id, opportunity.OwnerId, body, link);
                        mapBodyByOpportunityId.put(opportunity.Id,body);
                        mapLinkByOpportunityId.put(opportunity.Id,link);
                    }
                }

                when 'sendNotificationHasQuote'{

                    link = baseUrl + '/' + opportunity.Id;

                    body = '\n';
                    body += '***Atualização na oportunidade '+ opportunity.OpportunityNumber__c;
                    body += ' - ' + opportunity.Name +'*** \n';
                    body += 'Uma nova cotação foi disponibilizada, consulte no link:';

                    if(!Test.isRunningTest()){
                        //postChatter(opportunity.Id, opportunity.OwnerId, body, link);

                        mapBodyByOpportunityId.put(opportunity.Id,body);
                        mapLinkByOpportunityId.put(opportunity.Id,link);
                    }

                }
            }
        }
        postChatters(lstOpps, mapBodyByOpportunityId, mapLinkByOpportunityId);
    }
}