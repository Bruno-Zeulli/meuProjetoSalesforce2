/**
 * @description       : Distribuição das oportunidades com regra de distribuição com cálculo
 * @author            : samuelsirkis@.wiz.co
 * @group             :
 * @last modified on  : 09-25-2023
 * @last modified by  : samuelsirkis@wiz.co
 * Modifications Log
 * Ver  Date            Author                      Modification
 * 1.0  20-06-2023      samuelsirkis@.wiz.co        Initial Version
 **/
public with sharing class Conseg_OpportunityBO {

    /**
     * @description Distribui as oportunidades com base nas regras de distribuição.
     * @param opportunities Lista de oportunidades a serem distribuídas.
     * @param groupDeveloperName Nome do grupo a ser considerado para a distribuição.
     * @return Lista de oportunidades atualizadas com os proprietários distribuídos.
     */
    public static List<Opportunity> distributeOpportunity(List<Opportunity> opportunities,String groupDeveloperName){
        Map<String, List<Opportunity>> opportunityGroups = new Map<String, List<Opportunity>>();
        List<Opportunity> oppToUpdate = new List<Opportunity>();

        for(Opportunity opp : opportunities){
            // Agrupa as oportunidades de acordo com a estratégia
            if(opp.Estrategia5__c == 'Novo Seguro' || opp.Estrategia5__c == 'Renovação por outra corretora'){
                addToOpportunityGroup(opportunityGroups, 'Group1', opp);
            }else if(opp.Estrategia5__c == 'Renovação própria corretora'){
                addToOpportunityGroup(opportunityGroups, 'Group2', opp);
            }
        }

        // Distribui as oportunidades com base na comissão
        distributeByCommission(opportunityGroups, 0, 5, '0% - 5%',groupDeveloperName,oppToUpdate);
        distributeByCommission(opportunityGroups, 5.1, 10, '5.1% - 10%',groupDeveloperName,oppToUpdate);
        distributeByCommission(opportunityGroups, 10.1, 15, '10.1% - 15%',groupDeveloperName,oppToUpdate);
        distributeByCommission(opportunityGroups, 15.1, 35, '15.1% - 35%',groupDeveloperName,oppToUpdate);
        // distributeByCommission(opportunityGroups, 20.1, 25, '35.1% - 100%');

        return oppToUpdate;
    }

    /**
     * @description Adiciona uma oportunidade a um grupo de oportunidades no mapa.
     * @param opportunityGroups Mapa que contém os grupos de oportunidades.
     * @param groupKey Chave do grupo a ser adicionado.
     * @param opp Oportunidade a ser adicionada ao grupo.
     */
    private static void addToOpportunityGroup(Map<String, List<Opportunity>> opportunityGroups, String groupKey, Opportunity opp){
        if(!opportunityGroups.containsKey(groupKey)){
            opportunityGroups.put(groupKey, new List<Opportunity>());
        }
        opportunityGroups.get(groupKey).add(opp);
    }

    /**
     * @description Distribui as oportunidades com base na faixa de comissão.
     * @param opportunityGroups Mapa que contém os grupos de oportunidades.
     * @param minCommission Valor mínimo da faixa de comissão.
     * @param maxCommission Valor máximo da faixa de comissão.
     * @param commissionRange Faixa de comissão.
     * @param groupDeveloperName Nome do grupo a ser considerado para a distribuição.
     * @param oppToUpdate Lista de oportunidades a serem atualizadas com os proprietários distribuídos.
     * @return Lista de oportunidades atualizadas com os proprietários distribuídos.
     */
    private static List<Opportunity> distributeByCommission(Map<String, List<Opportunity>> opportunityGroups, Decimal minCommission, Decimal maxCommission, String commissionRange, String groupDeveloperName,List<Opportunity> oppToUpdate){
        Set<Id> userIds = new Set<Id>();
        List<String> lstUserIds = new List<String>();
        List<AggregateResult> lstAggregateResult = new List<AggregateResult>();
        AggregateResultWrapper[] lstAggregateResultWrapper = new List<AggregateResultWrapper>();

        // Obtém o grupo público com base no nome do desenvolvedor
        Group publicGroup = [SELECT Id FROM Group WHERE DeveloperName = :groupDeveloperName];
        for(GroupMember groupMember : [SELECT UserOrGroupId FROM GroupMember WHERE GroupId = :publicGroup.Id]){
            userIds.add(groupMember.UserOrGroupId);
        }
        // Obtém os usuários ativos no grupo
        List<User> lstUsers = [SELECT Id, Name, Email FROM User WHERE IsActive = true AND Id IN :userIds];

        for(User objUser : [SELECT Id
                            FROM User
                            WHERE Id IN :userIds
                            AND IsActive = true
                        ]){

            lstUserIds.add(objUser.Id);
        }

        // Realiza a contagem de oportunidades por proprietário
        lstAggregateResult = [SELECT COUNT(Id), OwnerId FROM Opportunity
                            WHERE RecordType.Name = 'Auto' AND OwnerId IN :userIds AND Owner.IsActive = true
                                    AND Estrategia5__c != null AND Estrategia4__c != null AND CreatedDate >= LAST_N_DAYS:2
                            GROUP BY OwnerId ORDER BY COUNT(Id)];

        System.debug('lstAggregateResult: ' + lstAggregateResult);
        for(AggregateResult objAggregateResult : lstAggregateResult){
            String srtUserId = (String) objAggregateResult.get('ownerId');
            Integer resultPosition = lstUserIds.indexOf(srtUserId);
            if(resultPosition >= 0){
                AggregateResultTO.AggResultDistributionOpps objAggResult = new AggregateResultTO.AggResultDistributionOpps();
                objAggResult.expr0 = (Integer) objAggregateResult.get('expr0');
                objAggResult.OwnerId = (String) objAggregateResult.get('ownerId');
                lstAggregateResultWrapper.add(new AggregateResultWrapper(objAggResult));
            }
        }
        System.debug('lstAggregateResultWrapper: ' + lstAggregateResultWrapper);

        Map<String,List<Opportunity>> groupCommissionRanges = new Map<String,List<Opportunity>>();

        // Agrupa as oportunidades de acordo com a faixa de comissão
        for(String groupKey : opportunityGroups.keySet()){
            List<Opportunity> groupOpportunities = opportunityGroups.get(groupKey);
            List<Opportunity> rangeGroups = new List<Opportunity>();

            for(Opportunity opp : groupOpportunities){
                Decimal commissionPercentage = Decimal.valueOf(opp.Estrategia4__c);
                if(commissionPercentage >= minCommission && commissionPercentage <= maxCommission){
                    rangeGroups.add(opp);
                }
            }

            if(!rangeGroups.isEmpty()){
                groupCommissionRanges.put(commissionRange, rangeGroups);
            }
        }
        System.debug('groupCommissionRanges: ' + groupCommissionRanges);

        for(String rangeKey : groupCommissionRanges.keySet()){
            List<Opportunity> rangeGroups = groupCommissionRanges.get(rangeKey);
            Integer sizeLstAggregateResult = lstAggregateResult.size();
            Integer sizeLstUserIds = lstUserIds.size();
            String srtUserId;
            System.debug('rangeGroups: ' + rangeGroups.size());

            Set<Id> processedIds = new Set<Id>();
            for(Opportunity opp : rangeGroups){

                for(AggregateResult agg : lstAggregateResult){
                    srtUserId = (String) agg.get('ownerId');
                        Integer resultPosition = lstUserIds.indexOf(srtUserId);
                        if(resultPosition >= 0){
                            lstUserIds.remove(resultPosition);
                        }
                    }

                if(sizeLstAggregateResult < sizeLstUserIds){
                    oppToUpdate.add(new Opportunity(
                        Id = opp.Id,
                        OwnerId = lstUserIds[0]
                    ));

                    lstUserIds.remove(0);
                    sizeLstUserIds--;

                }else if(!processedIds.contains(opp.Id)){
                    oppToUpdate.add(new Opportunity(
                        Id = opp.Id,
                        OwnerId = lstAggregateResultWrapper[0].agg.OwnerId
                        ));

                        AggregateResultTO.AggResultDistributionOpps objAggResult = lstAggregateResultWrapper[0].agg;
                        lstAggregateResultWrapper.remove(0);
                        Integer newValue = objAggResult.expr0;
                    objAggResult.expr0 = newValue + 1;
                    lstAggregateResultWrapper.add(new AggregateResultWrapper(objAggResult));
                }
                processedIds.add(opp.Id);
            }
        }
        System.debug('oppToUpdate: ' + oppToUpdate);
        // update oppToUpdate;
        return oppToUpdate;
    }
    /**
     * @description Adiciona uma oportunidade a um grupo de oportunidades no mapa.
     * @param lstSetOppIds Mapa que contém os grupos de oportunidades.
     * @return lstUpdOpportunity Chave do grupo a ser adicionado
     */
    public static List<Opportunity> distributionOpportunityConsegRemote(List<Opportunity> lstOpps){

        String srtUserId;
        Set<Id> lstSetOppIds = new Set<id>();
        List<Opportunity> lstUpdOpportunity = new List<Opportunity>();
        List<AggregateResult> lstAggregateResult = new List<AggregateResult>();
        List<String> lstUserId = new List<String>();
        AggregateResultWrapper[] lstAggregateResultWrapper = new List<AggregateResultWrapper>();

        for(Opportunity opp : lstopps){
            lstSetOppIds.add(opp.id);
        }

        lstAggregateResult = [SELECT COUNT(Id), OwnerId FROM Opportunity
                              WHERE Owner.Profile.Name = 'Conseg - Community User Remoto' AND Owner.IsActive = true
                              AND CreatedDate >= LAST_N_DAYS:2 AND (Campaign.Name like '%Five9%' OR Campaign.Name like '%Wauto%')
                              GROUP BY OwnerId ORDER BY COUNT(Id)];

        for(User objUser : [SELECT Id
                            FROM User
                            WHERE Profile.Name = 'Conseg - Community User Remoto'
                            AND IsActive = true
                        ]){

            lstUserId.add(objUser.Id);
        }

        if(!lstAggregateResult.isEmpty() && !lstUserId.isEmpty()){

            Integer sizeLstAggregateResult = lstAggregateResult.size();
            Integer sizeLstUserId = lstUserId.size();

            for(AggregateResult objAggregateResult : lstAggregateResult){
                srtUserId = (String) objAggregateResult.get('ownerId');
                Integer resultPosition = lstUserId.indexOf(srtUserId);
                if(resultPosition >= 0){
                    AggregateResultTO.AggResultDistributionOpps objAggResult = new AggregateResultTO.AggResultDistributionOpps();
                    objAggResult.expr0 = (Integer) objAggregateResult.get('expr0');
                    objAggResult.OwnerId = (String) objAggregateResult.get('ownerId');
                    lstAggregateResultWrapper.add(new AggregateResultWrapper(objAggResult));
                }
            }

            for(Opportunity objOpportunity : [SELECT Id FROM Opportunity WHERE (Campaign.Name like '%Five9%' OR Campaign.Name like '%Wauto%') AND Id IN: lstSetOppIds]){

                if(sizeLstAggregateResult < sizeLstUserId){
                    for(AggregateResult agg : lstAggregateResult){
                        srtUserId = (String) agg.get('ownerId');
                        Integer resultPosition = lstUserId.indexOf(srtUserId);
                        if(resultPosition >= 0){
                            lstUserId.remove(resultPosition);
                        }
                    }

                    lstUpdOpportunity.add(new Opportunity(
                        Id = objOpportunity.Id,
                        OwnerId = lstUserId[0]
                    ));

                    lstUserId.remove(0);
                    sizeLstUserId--;

                }else{
                    lstUpdOpportunity.add(new Opportunity(
                        Id = objOpportunity.Id,
                        OwnerId = lstAggregateResultWrapper[0].agg.OwnerId
                    ));

                    AggregateResultTO.AggResultDistributionOpps objAggResult = lstAggregateResultWrapper[0].agg;
                    lstAggregateResultWrapper.remove(0);
                    Integer newValue = objAggResult.expr0++;
                    objAggResult.expr0 = newValue;
                    lstAggregateResultWrapper.add(new AggregateResultWrapper(objAggResult));
                }
            }
        }
        return lstUpdOpportunity;
    }
     /**
     * @description Adiciona uma oportunidade a um grupo de oportunidades no mapa.
     * @param lstSetOppIds Mapa que contém os grupos de oportunidades.
     * @return lstUpdOpportunity Chave do grupo a ser adicionado
     */
    // public static List<Opportunity> distributionOpportunityConsegNew(List<Opportunity> lstOpps){

    //     String srtUserId;
    //     Set<Id> lstSetOppIds = new Set<id>();
    //     List<Opportunity> lstUpdOpportunity = new List<Opportunity>();
    //     List<AggregateResult> lstAggregateResult = new List<AggregateResult>();
    //     List<String> lstUserId = new List<String>();
    //     AggregateResultWrapper[] lstAggregateResultWrapper = new List<AggregateResultWrapper>();

    //     for(Opportunity opp : lstopps){
    //         lstSetOppIds.add(opp.id);
    //     }

    //     lstAggregateResult = [SELECT COUNT(Id), OwnerId FROM Opportunity
    //                           WHERE Owner.Profile.Name = 'Conseg - Community User' AND Owner.IsActive = true
    //                           AND CreatedDate >= LAST_N_DAYS:2 AND (Campaign.Name like '%Five9%' OR Campaign.Name like '%Wauto%')
    //                           GROUP BY OwnerId ORDER BY COUNT(Id)];

    //     for(User objUser : [SELECT Id
    //                         FROM User
    //                         WHERE Profile.Name = 'Conseg - Community User'
    //                         AND IsActive = true
    //                     ]){

    //         lstUserId.add(objUser.Id);
    //     }

    //     if(!lstAggregateResult.isEmpty() && !lstUserId.isEmpty()){

    //         Integer sizeLstAggregateResult = lstAggregateResult.size();
    //         Integer sizeLstUserId = lstUserId.size();

    //         for(AggregateResult objAggregateResult : lstAggregateResult){
    //             srtUserId = (String) objAggregateResult.get('ownerId');
    //             Integer resultPosition = lstUserId.indexOf(srtUserId);
    //             if(resultPosition >= 0){
    //                 AggregateResultTO.AggResultDistributionOpps objAggResult = new AggregateResultTO.AggResultDistributionOpps();
    //                 objAggResult.expr0 = (Integer) objAggregateResult.get('expr0');
    //                 objAggResult.OwnerId = (String) objAggregateResult.get('ownerId');
    //                 lstAggregateResultWrapper.add(new AggregateResultWrapper(objAggResult));
    //             }
    //         }

    //         for(Opportunity objOpportunity : [SELECT Id FROM Opportunity WHERE (Campaign.Name like '%Five9%' OR Campaign.Name like '%Wauto%') AND Id IN: lstSetOppIds]){

    //             if(sizeLstAggregateResult < sizeLstUserId){
    //                 for(AggregateResult agg : lstAggregateResult){
    //                     srtUserId = (String) agg.get('ownerId');
    //                     Integer resultPosition = lstUserId.indexOf(srtUserId);
    //                     if(resultPosition >= 0){
    //                         lstUserId.remove(resultPosition);
    //                     }
    //                 }

    //                 lstUpdOpportunity.add(new Opportunity(
    //                     Id = objOpportunity.Id,
    //                     OwnerId = lstUserId[0]
    //                 ));

    //                 lstUserId.remove(0);
    //                 sizeLstUserId--;

    //             }else{
    //                 lstUpdOpportunity.add(new Opportunity(
    //                     Id = objOpportunity.Id,
    //                     OwnerId = lstAggregateResultWrapper[0].agg.OwnerId
    //                 ));

    //                 AggregateResultTO.AggResultDistributionOpps objAggResult = lstAggregateResultWrapper[0].agg;
    //                 lstAggregateResultWrapper.remove(0);
    //                 Integer newValue = objAggResult.expr0++;
    //                 objAggResult.expr0 = newValue;
    //                 lstAggregateResultWrapper.add(new AggregateResultWrapper(objAggResult));
    //             }
    //         }
    //     }
    //     return lstUpdOpportunity;
    // }
    /** add */
}