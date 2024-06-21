public without sharing class ContactDAO {
    private static final ContactDAO INSTANCE = new ContactDAO();
    private static final Map<String, Object> MAP_OBJ_CONTACT = new Map<String, Object>();

    public static ContactDAO getInstance(){
        return INSTANCE;
    }

    public Map<String, Object> getAllFieldsByWhereCondition(String whereCondition){
        for(Contact objContact : getAllFields(whereCondition)){
            MAP_OBJ_CONTACT.put(objContact.Id, objContact);
        }
        return MAP_OBJ_CONTACT;
    }

    public List<Contact> getAllFields(String whereCondition){
        Map<String, Schema.SObjectType> globalMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = globalMap.get('Contact').getDescribe().fields.getMap();

        String query = 'SELECT ';

        for(String fieldName : fieldMap.keySet()){
            query += fieldName + ',';
        }

        query = query.substring(0, query.length() - 1) + ' FROM Contact ' + whereCondition;

        System.debug('@@@ getAllFields query: ' + query);

        return Database.query(query);
    }

    public static List<Contact> getContactByQuotationFormId(Set<Id> lFormsId){
        return [SELECT Id,Name,IsControlled__c,Type__c,PercentageOfTotalShares__c,PercentageOfPreferredShares__c,PercentageOfCommonShares__c,ParticipationPercentage__c,FirstAssembly__c,CountryOfOrigin__c,Activity__c,TechnicalSpecificationQuestionnaireId__c
                FROM Contact
                WHERE TechnicalSpecificationQuestionnaireId__c IN:lFormsId];
    }

    @AuraEnabled(cacheable=true)
    public static List<ContactObj> getBusinessPartnerContactByAccountOpportunityId(Id oppId){
        List<Opportunity> oppList = [SELECT AccountId FROM Opportunity WHERE Id =: oppId];
        
        if(oppList.size() == 0) return null;
        
        Id accountId = oppList[0].AccountId;

        List<ContactObj> contList = new List<ContactObj>();
        for(Contact cont : [SELECT Id, Name, CreatedDate FROM Contact WHERE AccountId =: accountId AND IsBusinessPartner__c = true]){
            contList.add(new ContactObj(cont));
        } 

        return contList;
    }

    public class ContactObj{
        public ContactObj(Contact cont){
            this.Name = cont.Name;
            this.CreatedDate = cont.CreatedDate;
        }
        @AuraEnabled public String Name;
        @AuraEnabled public Datetime CreatedDate;
    }
}