public without sharing class InsuranceInformationDAO {


    public static List<InsuranceInformation__C> getInsuranceInformationByFormsId(Set<Id> lFormId){
        return [SELECT  Id,
                        Company__c,
                        TermOfContract__c,
                        TechnicalSpecificationQuestionnaireId__c,
                        NumberOfLives__c,
                        HiringModel__c,
                        IndemnitiesPaid__c,
                        LimitOfLiability__c
                FROM    InsuranceInformation__C
                WHERE   TechnicalSpecificationQuestionnaireId__c IN:lFormId
                AND     Type__c = 'Dados da Operadora'];
    }

    public static List<InsuranceInformation__C> getCurrentPlansByInsurancesInformationId(Set<Id> lInsuranceInformationId){
        return [SELECT  Id,
                        PlanName__c,
                        ParentId__c,
                        ParentId__r.Company__c,
                        Company__c,
                        NumberOfLives__c,
                        PositionEligibility__c,
                        Cost__c,
                        Reimbursement__c,
                        ContributionHolder__c,
                        ContributionDependent__c,
                        coparticipation__c
                FROM    InsuranceInformation__C
                WHERE   ParentId__c IN:lInsuranceInformationId
                AND     Type__c = 'Plano atual'];
    }

    public static List<InsuranceInformation__C> getInsuranceSuggestionByCurrentPlanId(Set<Id> lCurrentPlanId){
        return [SELECT  Id,
                        PlanName__c,
                        PlanId__c,
                        Company__c,
                        PlanId__r.PlanName__c
                FROM    InsuranceInformation__C
                WHERE   PlanId__c IN:lCurrentPlanId
                AND     Type__c = 'Sugestão de plano'];
    }

    public static List<InsuranceInformation__C> getInsuranceInformationByOppId(String OpportunityId){
        return [SELECT  Id,
                        Company__c,
                        TermOfContract__c,
                        TechnicalSpecificationQuestionnaireId__c,
                        TechnicalSpecificationQuestionnaireId__r.Type__c
                FROM    InsuranceInformation__C
                WHERE   Type__c = 'Dados da Operadora'
                AND     TechnicalSpecificationQuestionnaireId__r.OpportunityId__c =:OpportunityId];
    }
}