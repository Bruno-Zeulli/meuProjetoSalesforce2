@isTest
public class FlowUpdateOwnerAccountTest 
{
    @isTest
    static void testUpdate()
    {
        FlowUpdateOwnerAccount.InputVariables up = new FlowUpdateOwnerAccount.InputVariables();
        Account acc = new Account(Name = 'Teste 01', IdentificationNumber__c = PersonalInformationUtil.generateRandomCNPJ());
        acc.CompanyIdentificationNumber__c = acc.IdentificationNumber__c;

        insert acc;
        User u = [SELECT Id FROM User LIMIT 1];
        
      	 List<String> IdAccountToUpdate = new List<String>();
         List<String> IdUserToUpdate = new List<String>();
         List<String> PjouPf = new List<String>();
        
        IdAccountToUpdate.add(acc.Id);
		IdUserToUpdate.add(u.Id);
		PjouPf.add('PF');
		
        up.IdAccountToUpdate = IdAccountToUpdate;
        up.IdUserToUpdate = IdUserToUpdate;
        up.PjouPf = PjouPf;
        
        List<FlowUpdateOwnerAccount.InputVariables> lstAh = new List<FlowUpdateOwnerAccount.InputVariables>();
        lstAh.add(up);
        FlowUpdateOwnerAccount.updateOwnerAccount(lstAh);
    }
}