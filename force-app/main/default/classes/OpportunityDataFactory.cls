/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
 **/
@isTest
public class OpportunityDataFactory {
	public static Opportunity insertVIPOpportunity(Id oppOwnerId, Id oppAccountId){
		Opportunity opp = createVIPOpportunity(oppOwnerId, oppAccountId);
		insert opp;
		return opp;
	}

	public static Opportunity createOpportunityWithRecordType(Id oppAccountId, String rtDeveloperName){
		Opportunity objOpportunity = setObjectOpportunity(oppAccountId, rtDeveloperName);
		insert objOpportunity;
		return objOpportunity;
	}

	public static Opportunity createOpportunity(){
		Opportunity opp = new Opportunity(Name = 'Test', StageName = 'Aberta', CloseDate = Date.today());
		return opp;
	}

	public static OpportunityTeamMember createOpportunityTeamMember(Opportunity opp, User u){
		OpportunityTeamMember oppT = new OpportunityTeamMember(
            OpportunityId = opp.Id,
            UserId = u.Id,
            TeamMemberRole = 'Account Manager'
		);
		return oppT;
	}

	public static Opportunity createOpportunityCorporateComercial(){
		Opportunity opp = new Opportunity(
            Name = TestDataFactory.generateRandomStringAlfa(10),
            StageName = 'Cotação',
            CloseDate = Date.today(),
            InsuredAmount__c = TestDataFactory.generateRandomNumber(4),
            RecordTypeId = getRecordTypeId('CorporateComercial')
		);
		return opp;
	}

	public static Opportunity createOpportunityCorporateBeneficios(){
		Opportunity opp = new Opportunity(
            Name = TestDataFactory.generateRandomStringAlfa(10),
            StageName = 'Cotação',
            CloseDate = Date.today(),
            InsuredAmount__c = TestDataFactory.generateRandomNumber(4),
            RecordTypeId = getRecordTypeId('CorporateBeneficios')
		);
		return opp;
	}

	public static Opportunity createVIPOpportunity(Id oppOwnerId, Id oppAccountId){
		Opportunity opp = new Opportunity(
            Name = 'Test',
            StageName = 'Aberta',
            CloseDate = Date.today(),
            RecordTypeId = getRecordTypeId('RedeVip'),
            AccountId = oppAccountId,
            OwnerId = oppOwnerId
		);
		return opp;
	}

	public static Opportunity setObjectOpportunity(Id oppAccountId, String rtDeveloperName){
		Opportunity objOpportunity = new Opportunity();
		objOpportunity.Name = TestDataFactory.generateRandomStringAlfa(10);
		objOpportunity.StageName = TestDataFactory.generateRandomStringAlfa(10);
		objOpportunity.CloseDate = Date.today();
		objOpportunity.RecordTypeId = getRecordTypeId(rtDeveloperName);
		objOpportunity.AccountId = oppAccountId;

		return objOpportunity;
	}

	private static Id getRecordTypeId(String rtDeveloperName){
		return Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(rtDeveloperName).getRecordTypeId();
	}

	public static string createDescriptionOppConseg(){

		String linebreak = '\r\n';
		String stringDescrition;

		stringDescrition += 'Modelo: CAOA CHERY TIGGO 5X TXS VERMELHO' + linebreak;
		stringDescrition += 'Chassi: 95PBCK51DNB030562' + linebreak;
		stringDescrition += 'Loja: D21-0390-CANOAS' + linebreak;
		stringDescrition += 'Vendedor: PERCIO MONTEIRO DE OLIVEIRA' + linebreak;
		stringDescrition += 'Cliente CEP: 93180000';

		return stringDescrition;
	}

}