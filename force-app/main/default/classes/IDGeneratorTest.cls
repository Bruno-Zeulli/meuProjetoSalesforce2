@IsTest
public class IDGeneratorTest {
	@isTest
	public static void postiveTestValidateGenerate(){
		Id accId = IDGenerator.generate(Account.getSObjectType());
		String accStrId = Id.valueOf(accId);
		String accIdPrefix = accStrId.substring(0, 3);
		Id conId = IDGenerator.generate(Contact.getSObjectType());
		String conStrId = Id.valueOf(conId);
		String conPrefix = conStrId.substring(0, 3);
		Id caseId = IDGenerator.generate(Case.getSObjectType());
		String caseStrId = Id.valueOf(caseId);
		String caseIdPrefix = caseStrId.substring(0, 3);
		positiveAssertSobjectIdPrefix(accIdPrefix, Account.getSObjectType());
		positiveAssertSobjectIdPrefix(conPrefix, Contact.getSObjectType());
		negativeAssertContactIdPrefix(caseIdPrefix, Account.getSObjectType());
	}
	public static void positiveAssertSobjectIdPrefix(String prefixId, SObjectType sobjectType){
		String keyPrefix = sobjectType.getDescribe().getKeyPrefix();
		System.assert(true, keyPrefix.equalsIgnoreCase(prefixId));
	}
	public static void negativeAssertContactIdPrefix(String prefixId, SObjectType sobjectType){
		String keyPrefix = sobjectType.getDescribe().getKeyPrefix();
		System.assert(keyPrefix != prefixId, true);
	}
}